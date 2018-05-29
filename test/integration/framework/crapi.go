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
	"fmt"
	"net/url"
	"os"

	"github.com/kubernetes-sig-testing/frameworks/integration"
	"github.com/kubernetes-sigs/kubebuilder/pkg/test"
	"k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1beta1"
	"k8s.io/cluster-registry/pkg/apis/clusterregistry/v1alpha1"
	crv1alpha1 "k8s.io/cluster-registry/pkg/client/clientset/versioned/typed/clusterregistry/v1alpha1"

	"github.com/kubernetes-sigs/federation-v2/test/common"
	"k8s.io/client-go/rest"
)

// ClusterRegistryApiFixture manages a api registry apiserver
type ClusterRegistryApiFixture struct {
	EtcdUrl             *url.URL
	Host                string
	SecureConfigFixture *SecureConfigFixture
	ClusterRegistryApi  *test.TestEnvironment
}

func SetUpClusterRegistryApiFixture(tl common.TestLogger) *ClusterRegistryApiFixture {
	f := &ClusterRegistryApiFixture{}
	f.setUp(tl)
	return f
}

func (f *ClusterRegistryApiFixture) setUp(tl common.TestLogger) {
	defer TearDownOnPanic(tl, f)

	f.EtcdUrl = EtcdURL(tl)
	f.SecureConfigFixture = SetUpSecureConfigFixture(tl)

	// TODO(marun) ensure resiliency in the face of another process
	// taking the port

	port, err := FindFreeLocalPort()
	if err != nil {
		tl.Fatal(err)
	}

	bindAddress := "127.0.0.1"
	f.Host = fmt.Sprintf("https://%s:%d", bindAddress, port)
	url, err := url.Parse(f.Host)
	if err != nil {
		tl.Fatalf("Error parsing url: %v", err)
	}

	testenv := &test.TestEnvironment{
		ControlPlane: integration.ControlPlane{
			APIServer: &integration.APIServer{
				URL:     url,
				CertDir: f.SecureConfigFixture.CertDir,
				EtcdURL: f.EtcdUrl,
				Out:     os.Stdout,
				Err:     os.Stderr,
			},
		},
		CRDs: []*v1beta1.CustomResourceDefinition{&v1alpha1.ClusterCRD}}

	_, err = testenv.Start()
	if err != nil {
		tl.Fatalf("Unexpected error: %v", err)
	}
	f.ClusterRegistryApi = testenv
}

func (f *ClusterRegistryApiFixture) TearDown(tl common.TestLogger) {
	if f.ClusterRegistryApi != nil {
		f.ClusterRegistryApi.Stop()
		f.ClusterRegistryApi = nil
	}
	if f.SecureConfigFixture != nil {
		f.SecureConfigFixture.TearDown(tl)
		f.SecureConfigFixture = nil
	}
	//	if len(f.EtcdUrl) > 0 {
	//		TearDownEtcd(tl)
	//		f.EtcdUrl = ""
	//	}
}

func (f *ClusterRegistryApiFixture) NewClient(tl common.TestLogger, userAgent string) *crv1alpha1.ClusterregistryV1alpha1Client {
	config := f.ClusterRegistryApi.Config
	client, _ := crv1alpha1.NewForConfig(config)
	return client
}

func (f *ClusterRegistryApiFixture) NewConfig(tl common.TestLogger) *rest.Config {
	return f.SecureConfigFixture.NewClientConfig(tl, f.Host)
}
