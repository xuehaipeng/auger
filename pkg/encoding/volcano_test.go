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

package encoding

import (
	"encoding/json"
	"testing"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime/serializer"
	"volcano.sh/apis/pkg/apis/batch/v1alpha1"

	"github.com/etcd-io/auger/pkg/scheme"
)

func TestVolcanoJobEncoding(t *testing.T) {
	// Create a simple Volcano Job object
	job := &v1alpha1.Job{
		TypeMeta: metav1.TypeMeta{
			APIVersion: "batch.volcano.sh/v1alpha1",
			Kind:       "Job",
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      "test-volcano-job",
			Namespace: "default",
		},
	}

	// Convert job to JSON
	jsonData, err := json.Marshal(job)
	if err != nil {
		t.Fatalf("Failed to marshal Volcano job to JSON: %v", err)
	}

	// Create a new codec factory using the scheme with Volcano API
	codecs := serializer.NewCodecFactory(scheme.Scheme)

	// Test conversion from JSON to YAML
	yamlData, typeMeta, err := Convert(codecs, JsonMediaType, YamlMediaType, jsonData)
	if err != nil {
		t.Fatalf("Failed to convert Volcano job from JSON to YAML: %v", err)
	}

	// Verify the type meta information is correct
	if typeMeta.APIVersion != "batch.volcano.sh/v1alpha1" {
		t.Errorf("Expected APIVersion batch.volcano.sh/v1alpha1, got %s", typeMeta.APIVersion)
	}
	if typeMeta.Kind != "Job" {
		t.Errorf("Expected Kind Job, got %s", typeMeta.Kind)
	}

	// Test conversion from YAML back to JSON
	jsonDataAgain, typeMeta, err := Convert(codecs, YamlMediaType, JsonMediaType, yamlData)
	if err != nil {
		t.Fatalf("Failed to convert Volcano job from YAML to JSON: %v", err)
	}

	// Verify the conversion was successful by decoding the JSON data
	jobAgain := &v1alpha1.Job{}
	if err := json.Unmarshal(jsonDataAgain, jobAgain); err != nil {
		t.Fatalf("Failed to unmarshal converted JSON data: %v", err)
	}

	// Verify the job data is still the same
	if jobAgain.Name != "test-volcano-job" || jobAgain.Namespace != "default" {
		t.Errorf("Job data was lost in conversion, expected name=test-volcano-job and namespace=default, got name=%s and namespace=%s",
			jobAgain.Name, jobAgain.Namespace)
	}
}

func TestVolcanoJobStorageBinaryEncoding(t *testing.T) {
	// Create a simple Volcano Job object
	job := &v1alpha1.Job{
		TypeMeta: metav1.TypeMeta{
			APIVersion: "batch.volcano.sh/v1alpha1",
			Kind:       "Job",
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      "test-volcano-job",
			Namespace: "default",
		},
	}

	// Convert job to JSON
	jsonData, err := json.Marshal(job)
	if err != nil {
		t.Fatalf("Failed to marshal Volcano job to JSON: %v", err)
	}

	// Create a new codec factory using the scheme with Volcano API
	codecs := serializer.NewCodecFactory(scheme.Scheme)

	// Test conversion from JSON to StorageBinaryMediaType
	// This should now use JSON as fallback instead of failing
	storageData, _, err := Convert(codecs, JsonMediaType, StorageBinaryMediaType, jsonData)
	if err != nil {
		t.Fatalf("Failed to convert Volcano job from JSON to StorageBinary: %v", err)
	}

	// Verify we get valid data back
	if len(storageData) == 0 {
		t.Fatal("No data returned from StorageBinary encoding")
	}

	// Verify we can convert back to JSON
	// Note: With our implementation, the StorageBinary format for Volcano jobs is just JSON
	// So we should be able to unmarshal it directly
	jobAgain := &v1alpha1.Job{}
	if err := json.Unmarshal(storageData, jobAgain); err != nil {
		t.Fatalf("Failed to unmarshal StorageBinary data: %v", err)
	}

	// Verify the job data is still the same
	if jobAgain.Name != "test-volcano-job" || jobAgain.Namespace != "default" {
		t.Errorf("Job data was lost in conversion, expected name=test-volcano-job and namespace=default, got name=%s and namespace=%s",
			jobAgain.Name, jobAgain.Namespace)
	}
}
