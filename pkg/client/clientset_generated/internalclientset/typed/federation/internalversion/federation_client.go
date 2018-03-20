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
package internalversion

import (
	"github.com/marun/fnord/pkg/client/clientset_generated/internalclientset/scheme"
	rest "k8s.io/client-go/rest"
)

type FederationInterface interface {
	RESTClient() rest.Interface
	FederatedClustersGetter
	FederatedConfigMapsGetter
	FederatedConfigMapOverridesGetter
	FederatedConfigMapPlacementsGetter
	FederatedNamespacePlacementsGetter
	FederatedReplicaSetsGetter
	FederatedReplicaSetOverridesGetter
	FederatedReplicaSetPlacementsGetter
	FederatedSecretsGetter
	FederatedSecretOverridesGetter
	FederatedSecretPlacementsGetter
}

// FederationClient is used to interact with features provided by the federation.k8s.io group.
type FederationClient struct {
	restClient rest.Interface
}

func (c *FederationClient) FederatedClusters() FederatedClusterInterface {
	return newFederatedClusters(c)
}

func (c *FederationClient) FederatedConfigMaps(namespace string) FederatedConfigMapInterface {
	return newFederatedConfigMaps(c, namespace)
}

func (c *FederationClient) FederatedConfigMapOverrides(namespace string) FederatedConfigMapOverrideInterface {
	return newFederatedConfigMapOverrides(c, namespace)
}

func (c *FederationClient) FederatedConfigMapPlacements(namespace string) FederatedConfigMapPlacementInterface {
	return newFederatedConfigMapPlacements(c, namespace)
}

func (c *FederationClient) FederatedNamespacePlacements() FederatedNamespacePlacementInterface {
	return newFederatedNamespacePlacements(c)
}

func (c *FederationClient) FederatedReplicaSets(namespace string) FederatedReplicaSetInterface {
	return newFederatedReplicaSets(c, namespace)
}

func (c *FederationClient) FederatedReplicaSetOverrides(namespace string) FederatedReplicaSetOverrideInterface {
	return newFederatedReplicaSetOverrides(c, namespace)
}

func (c *FederationClient) FederatedReplicaSetPlacements(namespace string) FederatedReplicaSetPlacementInterface {
	return newFederatedReplicaSetPlacements(c, namespace)
}

func (c *FederationClient) FederatedSecrets(namespace string) FederatedSecretInterface {
	return newFederatedSecrets(c, namespace)
}

func (c *FederationClient) FederatedSecretOverrides(namespace string) FederatedSecretOverrideInterface {
	return newFederatedSecretOverrides(c, namespace)
}

func (c *FederationClient) FederatedSecretPlacements(namespace string) FederatedSecretPlacementInterface {
	return newFederatedSecretPlacements(c, namespace)
}

// NewForConfig creates a new FederationClient for the given config.
func NewForConfig(c *rest.Config) (*FederationClient, error) {
	config := *c
	if err := setConfigDefaults(&config); err != nil {
		return nil, err
	}
	client, err := rest.RESTClientFor(&config)
	if err != nil {
		return nil, err
	}
	return &FederationClient{client}, nil
}

// NewForConfigOrDie creates a new FederationClient for the given config and
// panics if there is an error in the config.
func NewForConfigOrDie(c *rest.Config) *FederationClient {
	client, err := NewForConfig(c)
	if err != nil {
		panic(err)
	}
	return client
}

// New creates a new FederationClient for the given RESTClient.
func New(c rest.Interface) *FederationClient {
	return &FederationClient{c}
}

func setConfigDefaults(config *rest.Config) error {
	g, err := scheme.Registry.Group("federation.k8s.io")
	if err != nil {
		return err
	}

	config.APIPath = "/apis"
	if config.UserAgent == "" {
		config.UserAgent = rest.DefaultKubernetesUserAgent()
	}
	if config.GroupVersion == nil || config.GroupVersion.Group != g.GroupVersion.Group {
		gv := g.GroupVersion
		config.GroupVersion = &gv
	}
	config.NegotiatedSerializer = scheme.Codecs

	if config.QPS == 0 {
		config.QPS = 5
	}
	if config.Burst == 0 {
		config.Burst = 10
	}

	return nil
}

// RESTClient returns a RESTClient that is used to communicate
// with API server by this client implementation.
func (c *FederationClient) RESTClient() rest.Interface {
	if c == nil {
		return nil
	}
	return c.restClient
}
