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

// This file was automatically generated by informer-gen

package internalversion

import (
	internalinterfaces "github.com/kubernetes-sigs/federation-v2/pkg/client/informers_generated/internalversion/internalinterfaces"
)

// Interface provides access to all the informers in this group version.
type Interface interface {
	// FederatedClusters returns a FederatedClusterInformer.
	FederatedClusters() FederatedClusterInformer
	// FederatedConfigMaps returns a FederatedConfigMapInformer.
	FederatedConfigMaps() FederatedConfigMapInformer
	// FederatedConfigMapOverrides returns a FederatedConfigMapOverrideInformer.
	FederatedConfigMapOverrides() FederatedConfigMapOverrideInformer
	// FederatedConfigMapPlacements returns a FederatedConfigMapPlacementInformer.
	FederatedConfigMapPlacements() FederatedConfigMapPlacementInformer
	// FederatedNamespacePlacements returns a FederatedNamespacePlacementInformer.
	FederatedNamespacePlacements() FederatedNamespacePlacementInformer
	// FederatedReplicaSets returns a FederatedReplicaSetInformer.
	FederatedReplicaSets() FederatedReplicaSetInformer
	// FederatedReplicaSetOverrides returns a FederatedReplicaSetOverrideInformer.
	FederatedReplicaSetOverrides() FederatedReplicaSetOverrideInformer
	// FederatedReplicaSetPlacements returns a FederatedReplicaSetPlacementInformer.
	FederatedReplicaSetPlacements() FederatedReplicaSetPlacementInformer
	// FederatedSecrets returns a FederatedSecretInformer.
	FederatedSecrets() FederatedSecretInformer
	// FederatedSecretOverrides returns a FederatedSecretOverrideInformer.
	FederatedSecretOverrides() FederatedSecretOverrideInformer
	// FederatedSecretPlacements returns a FederatedSecretPlacementInformer.
	FederatedSecretPlacements() FederatedSecretPlacementInformer
}

type version struct {
	factory          internalinterfaces.SharedInformerFactory
	namespace        string
	tweakListOptions internalinterfaces.TweakListOptionsFunc
}

// New returns a new Interface.
func New(f internalinterfaces.SharedInformerFactory, namespace string, tweakListOptions internalinterfaces.TweakListOptionsFunc) Interface {
	return &version{factory: f, namespace: namespace, tweakListOptions: tweakListOptions}
}

// FederatedClusters returns a FederatedClusterInformer.
func (v *version) FederatedClusters() FederatedClusterInformer {
	return &federatedClusterInformer{factory: v.factory, tweakListOptions: v.tweakListOptions}
}

// FederatedConfigMaps returns a FederatedConfigMapInformer.
func (v *version) FederatedConfigMaps() FederatedConfigMapInformer {
	return &federatedConfigMapInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}

// FederatedConfigMapOverrides returns a FederatedConfigMapOverrideInformer.
func (v *version) FederatedConfigMapOverrides() FederatedConfigMapOverrideInformer {
	return &federatedConfigMapOverrideInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}

// FederatedConfigMapPlacements returns a FederatedConfigMapPlacementInformer.
func (v *version) FederatedConfigMapPlacements() FederatedConfigMapPlacementInformer {
	return &federatedConfigMapPlacementInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}

// FederatedNamespacePlacements returns a FederatedNamespacePlacementInformer.
func (v *version) FederatedNamespacePlacements() FederatedNamespacePlacementInformer {
	return &federatedNamespacePlacementInformer{factory: v.factory, tweakListOptions: v.tweakListOptions}
}

// FederatedReplicaSets returns a FederatedReplicaSetInformer.
func (v *version) FederatedReplicaSets() FederatedReplicaSetInformer {
	return &federatedReplicaSetInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}

// FederatedReplicaSetOverrides returns a FederatedReplicaSetOverrideInformer.
func (v *version) FederatedReplicaSetOverrides() FederatedReplicaSetOverrideInformer {
	return &federatedReplicaSetOverrideInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}

// FederatedReplicaSetPlacements returns a FederatedReplicaSetPlacementInformer.
func (v *version) FederatedReplicaSetPlacements() FederatedReplicaSetPlacementInformer {
	return &federatedReplicaSetPlacementInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}

// FederatedSecrets returns a FederatedSecretInformer.
func (v *version) FederatedSecrets() FederatedSecretInformer {
	return &federatedSecretInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}

// FederatedSecretOverrides returns a FederatedSecretOverrideInformer.
func (v *version) FederatedSecretOverrides() FederatedSecretOverrideInformer {
	return &federatedSecretOverrideInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}

// FederatedSecretPlacements returns a FederatedSecretPlacementInformer.
func (v *version) FederatedSecretPlacements() FederatedSecretPlacementInformer {
	return &federatedSecretPlacementInformer{factory: v.factory, namespace: v.namespace, tweakListOptions: v.tweakListOptions}
}
