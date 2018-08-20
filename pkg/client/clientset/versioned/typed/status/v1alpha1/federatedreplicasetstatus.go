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

// Code generated by client-gen. DO NOT EDIT.

package v1alpha1

import (
	v1alpha1 "github.com/kubernetes-sigs/federation-v2/pkg/apis/status/v1alpha1"
	scheme "github.com/kubernetes-sigs/federation-v2/pkg/client/clientset/versioned/scheme"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	types "k8s.io/apimachinery/pkg/types"
	watch "k8s.io/apimachinery/pkg/watch"
	rest "k8s.io/client-go/rest"
)

// FederatedReplicaSetStatusesGetter has a method to return a FederatedReplicaSetStatusInterface.
// A group's client should implement this interface.
type FederatedReplicaSetStatusesGetter interface {
	FederatedReplicaSetStatuses(namespace string) FederatedReplicaSetStatusInterface
}

// FederatedReplicaSetStatusInterface has methods to work with FederatedReplicaSetStatus resources.
type FederatedReplicaSetStatusInterface interface {
	Create(*v1alpha1.FederatedReplicaSetStatus) (*v1alpha1.FederatedReplicaSetStatus, error)
	Update(*v1alpha1.FederatedReplicaSetStatus) (*v1alpha1.FederatedReplicaSetStatus, error)
	UpdateStatus(*v1alpha1.FederatedReplicaSetStatus) (*v1alpha1.FederatedReplicaSetStatus, error)
	Delete(name string, options *v1.DeleteOptions) error
	DeleteCollection(options *v1.DeleteOptions, listOptions v1.ListOptions) error
	Get(name string, options v1.GetOptions) (*v1alpha1.FederatedReplicaSetStatus, error)
	List(opts v1.ListOptions) (*v1alpha1.FederatedReplicaSetStatusList, error)
	Watch(opts v1.ListOptions) (watch.Interface, error)
	Patch(name string, pt types.PatchType, data []byte, subresources ...string) (result *v1alpha1.FederatedReplicaSetStatus, err error)
	FederatedReplicaSetStatusExpansion
}

// federatedReplicaSetStatuses implements FederatedReplicaSetStatusInterface
type federatedReplicaSetStatuses struct {
	client rest.Interface
	ns     string
}

// newFederatedReplicaSetStatuses returns a FederatedReplicaSetStatuses
func newFederatedReplicaSetStatuses(c *StatusV1alpha1Client, namespace string) *federatedReplicaSetStatuses {
	return &federatedReplicaSetStatuses{
		client: c.RESTClient(),
		ns:     namespace,
	}
}

// Get takes name of the federatedReplicaSetStatus, and returns the corresponding federatedReplicaSetStatus object, and an error if there is any.
func (c *federatedReplicaSetStatuses) Get(name string, options v1.GetOptions) (result *v1alpha1.FederatedReplicaSetStatus, err error) {
	result = &v1alpha1.FederatedReplicaSetStatus{}
	err = c.client.Get().
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		Name(name).
		VersionedParams(&options, scheme.ParameterCodec).
		Do().
		Into(result)
	return
}

// List takes label and field selectors, and returns the list of FederatedReplicaSetStatuses that match those selectors.
func (c *federatedReplicaSetStatuses) List(opts v1.ListOptions) (result *v1alpha1.FederatedReplicaSetStatusList, err error) {
	result = &v1alpha1.FederatedReplicaSetStatusList{}
	err = c.client.Get().
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		VersionedParams(&opts, scheme.ParameterCodec).
		Do().
		Into(result)
	return
}

// Watch returns a watch.Interface that watches the requested federatedReplicaSetStatuses.
func (c *federatedReplicaSetStatuses) Watch(opts v1.ListOptions) (watch.Interface, error) {
	opts.Watch = true
	return c.client.Get().
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		VersionedParams(&opts, scheme.ParameterCodec).
		Watch()
}

// Create takes the representation of a federatedReplicaSetStatus and creates it.  Returns the server's representation of the federatedReplicaSetStatus, and an error, if there is any.
func (c *federatedReplicaSetStatuses) Create(federatedReplicaSetStatus *v1alpha1.FederatedReplicaSetStatus) (result *v1alpha1.FederatedReplicaSetStatus, err error) {
	result = &v1alpha1.FederatedReplicaSetStatus{}
	err = c.client.Post().
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		Body(federatedReplicaSetStatus).
		Do().
		Into(result)
	return
}

// Update takes the representation of a federatedReplicaSetStatus and updates it. Returns the server's representation of the federatedReplicaSetStatus, and an error, if there is any.
func (c *federatedReplicaSetStatuses) Update(federatedReplicaSetStatus *v1alpha1.FederatedReplicaSetStatus) (result *v1alpha1.FederatedReplicaSetStatus, err error) {
	result = &v1alpha1.FederatedReplicaSetStatus{}
	err = c.client.Put().
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		Name(federatedReplicaSetStatus.Name).
		Body(federatedReplicaSetStatus).
		Do().
		Into(result)
	return
}

// UpdateStatus was generated because the type contains a Status member.
// Add a +genclient:noStatus comment above the type to avoid generating UpdateStatus().

func (c *federatedReplicaSetStatuses) UpdateStatus(federatedReplicaSetStatus *v1alpha1.FederatedReplicaSetStatus) (result *v1alpha1.FederatedReplicaSetStatus, err error) {
	result = &v1alpha1.FederatedReplicaSetStatus{}
	err = c.client.Put().
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		Name(federatedReplicaSetStatus.Name).
		SubResource("status").
		Body(federatedReplicaSetStatus).
		Do().
		Into(result)
	return
}

// Delete takes name of the federatedReplicaSetStatus and deletes it. Returns an error if one occurs.
func (c *federatedReplicaSetStatuses) Delete(name string, options *v1.DeleteOptions) error {
	return c.client.Delete().
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		Name(name).
		Body(options).
		Do().
		Error()
}

// DeleteCollection deletes a collection of objects.
func (c *federatedReplicaSetStatuses) DeleteCollection(options *v1.DeleteOptions, listOptions v1.ListOptions) error {
	return c.client.Delete().
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		VersionedParams(&listOptions, scheme.ParameterCodec).
		Body(options).
		Do().
		Error()
}

// Patch applies the patch and returns the patched federatedReplicaSetStatus.
func (c *federatedReplicaSetStatuses) Patch(name string, pt types.PatchType, data []byte, subresources ...string) (result *v1alpha1.FederatedReplicaSetStatus, err error) {
	result = &v1alpha1.FederatedReplicaSetStatus{}
	err = c.client.Patch(pt).
		Namespace(c.ns).
		Resource("federatedreplicasetstatuses").
		SubResource(subresources...).
		Name(name).
		Body(data).
		Do().
		Into(result)
	return
}