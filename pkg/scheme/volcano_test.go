/*
Copyright The Kubernetes Authors.

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

package scheme

import (
	"testing"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	volcanobatchv1alpha1 "volcano.sh/apis/pkg/apis/batch/v1alpha1"
)

func TestVolcanoJobScheme(t *testing.T) {
	// Create a simple Volcano Job object
	job := &volcanobatchv1alpha1.Job{
		TypeMeta: metav1.TypeMeta{
			APIVersion: "batch.volcano.sh/v1alpha1",
			Kind:       "Job",
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      "test-volcano-job",
			Namespace: "default",
		},
	}

	// Verify the job can be added to the scheme
	err := volcanobatchv1alpha1.AddToScheme(Scheme)
	if err != nil {
		t.Fatalf("Failed to add volcano batch v1alpha1 to scheme: %v", err)
	}

	// Check if the scheme can recognize the GVK (Group Version Kind) of the Volcano Job
	gvks, _, err := Scheme.ObjectKinds(job)
	if err != nil {
		t.Fatalf("Failed to get object kinds for Volcano Job: %v", err)
	}

	if len(gvks) == 0 {
		t.Fatal("No GroupVersionKind returned for Volcano Job")
	}

	found := false
	for _, gvk := range gvks {
		if gvk.Group == "batch.volcano.sh" && gvk.Version == "v1alpha1" && gvk.Kind == "Job" {
			found = true
			break
		}
	}

	if !found {
		t.Fatalf("Expected GVK not found in: %v", gvks)
	}
}
