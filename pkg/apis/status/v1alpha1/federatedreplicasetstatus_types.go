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

package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// FederatedReplicaSetStatusSpec defines the desired state of FederatedReplicaSetStatus
type FederatedReplicaSetStatusSpec struct {
}

// FederatedReplicaSetStatusStatus defines the observed state of FederatedReplicaSetStatus
type FederatedReplicaSetStatusStatus struct {
	ClusterStatuses []FederatedClusterStatus `json:"federatedClusterStatus,omitempty"`
}

// FederatedClusterStatus defines name and replica status of clusters in replicaset
type FederatedClusterStatus struct {
	// clusterName is the name of the cluster
	ClusterName string `json:"clusterName,omitempty"`
	// replicas is the number of replicas in the cluster at the time of reconciliation by the controller.
	Replicas int32 `json:"replicas" protobuf:"varint,2,opt,name=replicas"`
	// readyReplicas is the number of replicas in the cluster that have a Ready Condition.
	ReadyReplicas int32 `json:"readyReplicas,omitempty" protobuf:"varint,3,opt,name=readyReplicas"`
}

// +genclient
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// FederatedReplicaSetStatus
// +k8s:openapi-gen=true
// +kubebuilder:resource:path=federatedreplicasetstatuses
type FederatedReplicaSetStatus struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   FederatedReplicaSetStatusSpec   `json:"spec,omitempty"`
	Status FederatedReplicaSetStatusStatus `json:"status,omitempty"`
}
