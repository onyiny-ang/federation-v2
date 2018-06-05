/*
Copyright 2018 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package framework

import (
	"bytes"
	"io/ioutil"
	"log"

	"github.com/kubernetes-sigs/federation-v2/pkg/controller/util"
	"github.com/kubernetes-sigs/federation-v2/test/common"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/wait"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/rest"
)

// ClusterRegistryApiFixture manages a api registry apiserver
type ClusterRegistryApiFixture struct {
	KubeAPIFixture *KubernetesApiFixture
}

func SetUpClusterRegistryApiFixture(tl common.TestLogger) *ClusterRegistryApiFixture {
	f := &ClusterRegistryApiFixture{}
	f.setUp(tl)
	return f
}

func (f *ClusterRegistryApiFixture) setUp(tl common.TestLogger) {
	defer TearDownOnPanic(tl, f)
	f.KubeAPIFixture = SetUpKubernetesApiFixture(tl)
}

func (f *ClusterRegistryApiFixture) TearDown(tl common.TestLogger) {
	if f.KubeAPIFixture != nil {
		f.KubeAPIFixture.TearDown(tl)
		f.KubeAPIFixture = nil
	}
}

func (f *ClusterRegistryApiFixture) NewClient(tl common.TestLogger, userAgent string) util.ResourceClient {
	kubeConfig := f.NewConfig(tl)
	rest.AddUserAgent(kubeConfig, userAgent)

	pool := dynamic.NewDynamicClientPool(kubeConfig)
	crdApiResource := &metav1.APIResource{
		Group:      "apiextensions.k8s.io",
		Version:    "v1beta1",
		Name:       "customresourcedefinitions",
		Namespaced: false,
	}
	crdClient, err := util.NewResourceClient(pool, crdApiResource)

	crdyaml, err := ioutil.ReadFile("cluster-registry-crd.yaml")
	if err != nil {
		log.Printf("crdyaml.Get err   #%v ", err)
	}

	crd, err := common.ReaderToObj(bytes.NewReader(crdyaml))
	if err != nil {
		tl.Fatalf("Error loading test object: %v", err)
	}
	_, err = crdClient.Resources("").Create(crd)
	if err != nil {
		tl.Fatalf("Error creating crd: %v", err)
	}

	apiResource := &metav1.APIResource{
		Group:      "clusterregistry.k8s.io",
		Version:    "v1alpha1",
		Kind:       "Cluster",
		Name:       "Cluster",
		Namespaced: true,
	}

	client, err := util.NewResourceClient(pool, apiResource)
	if err != nil {
		tl.Fatalf("Error creating client for crd %q: %v", apiResource.Kind, err)
	}

	// Wait for crd api to become available
	err = wait.PollImmediate(DefaultWaitInterval, wait.ForeverTestTimeout, func() (bool, error) {
		_, err := client.Resources("invalid").Get("invalid", metav1.GetOptions{})
		if errors.IsNotFound(err) {
			return true, nil
		}
		return (err == nil), err
	})
	if err != nil {
		tl.Fatalf("Error waiting for crd %q to become established: %v", apiResource.Kind, err)
	}

	return client
}

func (f *ClusterRegistryApiFixture) NewConfig(tl common.TestLogger) *rest.Config {
	return f.KubeAPIFixture.NewConfig(tl)
}
