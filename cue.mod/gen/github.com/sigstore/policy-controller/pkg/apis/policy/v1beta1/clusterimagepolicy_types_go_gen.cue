// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/sigstore/policy-controller/pkg/apis/policy/v1beta1

package v1beta1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/api/core/v1"
	"knative.dev/pkg/apis"
)

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
#ClusterImagePolicy: {
	metav1.#TypeMeta
	metadata: metav1.#ObjectMeta @go(ObjectMeta)

	// Spec holds the desired state of the ClusterImagePolicy (from the client).
	spec: #ClusterImagePolicySpec @go(Spec)
}

// ClusterImagePolicySpec defines a list of images that should be verified
#ClusterImagePolicySpec: {
	// Images defines the patterns of image names that should be subject to this policy.
	images: [...#ImagePattern] @go(Images,[]ImagePattern)

	// Authorities defines the rules for discovering and validating signatures.
	// +optional
	authorities?: [...#Authority] @go(Authorities,[]Authority)

	// Policy is an optional policy that can be applied against all the
	// successfully validated Authorities. If no authorities pass, this does
	// not even get evaluated, as the Policy is considered failed.
	// +optional
	policy?: null | #Policy @go(Policy,*Policy)

	// Mode controls whether a failing policy will be rejected (not admitted),
	// or if errors are converted to Warnings.
	// enforce - Reject (default)
	// warn - allow but warn
	// +optional
	mode?: string @go(Mode)

	// Match allows selecting resources based on their properties.
	// +optional
	match?: [...#MatchResource] @go(Match,[]MatchResource)
}

// ImagePattern defines a pattern and its associated authorties
// If multiple patterns match a particular image, then ALL of
// those authorities must be satisfied for the image to be admitted.
#ImagePattern: {
	// Glob defines a globbing pattern.
	glob: string @go(Glob)
}

// The authorities block defines the rules for discovering and
// validating signatures.  Signatures are
// cryptographically verified using one of the "key" or "keyless"
// fields.
// When multiple authorities are specified, any of them may be used
// to source the valid signature we are looking for to admit an
// image.
#Authority: {
	// Name is the name for this authority. Used by the CIP Policy
	// validator to be able to reference matching signature or attestation
	// verifications.
	// If not specified, the name will be authority-<index in array>
	name: string @go(Name)

	// Key defines the type of key to validate the image.
	// +optional
	key?: null | #KeyRef @go(Key,*KeyRef)

	// Keyless sets the configuration to verify the authority against a Fulcio instance.
	// +optional
	keyless?: null | #KeylessRef @go(Keyless,*KeylessRef)

	// Static specifies that signatures / attestations are not validated but
	// instead a static policy is applied against matching images.
	// +optional
	static?: null | #StaticRef @go(Static,*StaticRef)

	// Sources sets the configuration to specify the sources from where to consume the signatures.
	// +optional
	source?: [...#Source] @go(Sources,[]Source)

	// CTLog sets the configuration to verify the authority against a Rekor instance.
	// +optional
	ctlog?: null | #TLog @go(CTLog,*TLog)

	// Attestations is a list of individual attestations for this authority,
	// once the signature for this authority has been verified.
	// +optional
	attestations?: [...#Attestation] @go(Attestations,[]Attestation)

	// RFC3161Timestamp sets the configuration to verify the signature timestamp against a RFC3161 time-stamping instance.
	// +optional
	rfc3161timestamp?: null | #RFC3161Timestamp @go(RFC3161Timestamp,*RFC3161Timestamp)
}

// This references a public verification key stored in
// a secret in the cosign-system namespace.
// A KeyRef must specify only one of SecretRef, Data or KMS
#KeyRef: {
	// SecretRef sets a reference to a secret with the key.
	// +optional
	secretRef?: null | v1.#SecretReference @go(SecretRef,*v1.SecretReference)

	// Data contains the inline public key.
	// +optional
	data?: string @go(Data)

	// KMS contains the KMS url of the public key
	// Supported formats differ based on the KMS system used.
	// +optional
	kms?: string @go(KMS)

	// HashAlgorithm always defaults to sha256 if the algorithm hasn't been explicitly set
	// +optional
	hashAlgorithm?: string @go(HashAlgorithm)
}

// StaticRef specifies that signatures / attestations are not validated but
// instead a static policy is applied against matching images.
#StaticRef: {
	// Action defines how to handle a matching policy.
	action: string @go(Action)
}

// Source specifies the location of the signature
#Source: {
	// OCI defines the registry from where to pull the signatures.
	// +optional
	oci?: string @go(OCI)

	// SignaturePullSecrets is an optional list of references to secrets in the
	// same namespace as the deploying resource for pulling any of the signatures
	// used by this Source.
	// +optional
	signaturePullSecrets?: [...v1.#LocalObjectReference] @go(SignaturePullSecrets,[]v1.LocalObjectReference)
}

// TLog specifies the URL to a transparency log that holds
// the signature and public key information
#TLog: {
	// URL sets the url to the rekor instance (by default the public rekor.sigstore.dev)
	// +optional
	url?: null | apis.#URL @go(URL,*apis.URL)

	// Use the Public Key from the referred TrustRoot.TLog
	// +optional
	trustRootRef?: string @go(TrustRootRef)
}

// KeylessRef contains location of the validating certificate and the identities
// against which to verify. KeylessRef will contain either the URL to the verifying
// certificate, or it will contain the certificate data inline or in a secret.
#KeylessRef: {
	// URL defines a url to the keyless instance.
	// +optional
	url?: null | apis.#URL @go(URL,*apis.URL)

	// Identities sets a list of identities.
	identities: [...#Identity] @go(Identities,[]Identity)

	// CACert sets a reference to CA certificate
	// +optional
	"ca-cert"?: null | #KeyRef @go(CACert,*KeyRef)

	// Use the Certificate Chain from the referred TrustRoot.CertificateAuthorities and TrustRoot.CTLog
	// +optional
	trustRootRef?: string @go(TrustRootRef)

	// InsecureIgnoreSCT omits verifying if a certificate contains an embedded SCT
	// +optional
	insecureIgnoreSCT?: null | bool @go(InsecureIgnoreSCT,*bool)
}

// Attestation defines the type of attestation to validate and optionally
// apply a policy decision to it. Authority block is used to verify the
// specified attestation types, and if Policy is specified, then it's applied
// only after the validation of the Attestation signature has been verified.
#Attestation: {
	// Name of the attestation. These can then be referenced at the CIP level
	// policy.
	name: string @go(Name)

	// PredicateType defines which predicate type to verify. Matches cosign verify-attestation options.
	predicateType: string @go(PredicateType)

	// Policy defines all of the matching signatures, and all of
	// the matching attestations (whose attestations are verified).
	// +optional
	policy?: null | #Policy @go(Policy,*Policy)
}

// RemotePolicy defines all the properties to fetch a remote policy
#RemotePolicy: {
	// URL to the policy data.
	url?: apis.#URL @go(URL)

	// Sha256sum defines the exact sha256sum computed out of the 'body' of the http response.
	sha256sum?: string @go(Sha256sum)
}

// Policy specifies a policy to use for Attestation or the CIP validation (iff
// at least one authority matches).
// Exactly one of Data, URL, or ConfigMapReference must be specified.
#Policy: {
	// Which kind of policy this is, currently only rego or cue are supported.
	// Furthermore, only cue is tested :)
	type: string @go(Type)

	// Data contains the policy definition.
	// +optional
	data?: string @go(Data)

	// Remote defines the url to a policy.
	// +optional
	remote?: null | #RemotePolicy @go(Remote,*RemotePolicy)

	// ConfigMapRef defines the reference to a configMap with the policy definition.
	// +optional
	configMapRef?: null | #ConfigMapReference @go(ConfigMapRef,*ConfigMapReference)

	// FetchConfigFile controls whether ConfigFile will be fetched and made
	// available for CIP level policy evaluation. Note that this only gets
	// evaluated (and hence fetched) iff at least one authority matches.
	// The ConfigFile will then be available in this format:
	// https://github.com/opencontainers/image-spec/blob/main/config.md
	// +optional
	fetchConfigFile?: null | bool @go(FetchConfigFile,*bool)

	// IncludeSpec controls whether resource `Spec` will be included and
	// made available for CIP level policy evaluation. Note that this only gets
	// evaluated iff at least one authority matches.
	// Also note that because Spec may be of a different shape depending
	// on the resource being evaluatied (see MatchResource for filtering)
	// you might want to configure these to match the policy file to ensure
	// the shape of the Spec is what you expect when evaling the policy.
	// +optional
	includeSpec?: null | bool @go(IncludeSpec,*bool)

	// IncludeObjectMeta controls whether the ObjectMeta will be included and
	// made available for CIP level policy evalutation. Note that this only gets
	// evaluated iff at least one authority matches.
	// +optional
	includeObjectMeta?: null | bool @go(IncludeObjectMeta,*bool)

	// IncludeTypeMeta controls whether the TypeMeta will be included and
	// made available for CIP level policy evalutation. Note that this only gets
	// evaluated iff at least one authority matches.
	// +optional
	includeTypeMeta?: null | bool @go(IncludeTypeMeta,*bool)
}

// MatchResource allows selecting resources based on its version, group and resource.
// It is also possible to select resources based on a list of matching labels.
#MatchResource: {
	metav1.#GroupVersionResource

	// +optional
	selector?: null | metav1.#LabelSelector @go(ResourceSelector,*metav1.LabelSelector)
}

// ConfigMapReference is cut&paste from SecretReference, but for the life of me
// couldn't find one in the public types. If there's one, use it.
#ConfigMapReference: {
	// Name is unique within a namespace to reference a configmap resource.
	// +optional
	name?: string @go(Name)

	// Namespace defines the space within which the configmap name must be unique.
	// +optional
	namespace?: string @go(Namespace)

	// Key defines the key to pull from the configmap.
	// +optional
	key?: string @go(Key)
}

// Identity may contain the issuer and/or the subject found in the transparency
// log.
// Issuer/Subject uses a strict match, while IssuerRegExp and SubjectRegExp
// apply a regexp for matching.
#Identity: {
	// Issuer defines the issuer for this identity.
	// +optional
	issuer?: string @go(Issuer)

	// Subject defines the subject for this identity.
	// +optional
	subject?: string @go(Subject)

	// IssuerRegExp specifies a regular expression to match the issuer for this identity.
	// +optional
	issuerRegExp?: string @go(IssuerRegExp)

	// SubjectRegExp specifies a regular expression to match the subject for this identity.
	// +optional
	subjectRegExp?: string @go(SubjectRegExp)
}

// RFC3161Timestamp specifies the URL to a RFC3161 time-stamping server that holds
// the time-stamped verification for the signature
#RFC3161Timestamp: {
	// Use the Certificate Chain from the referred TrustRoot.TimeStampAuthorities
	// +optional
	trustRootRef?: string @go(TrustRootRef)
}

// ClusterImagePolicyList is a list of ClusterImagePolicy resources
//
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
#ClusterImagePolicyList: {
	metav1.#TypeMeta
	metadata: metav1.#ListMeta @go(ListMeta)
	items: [...#ClusterImagePolicy] @go(Items,[]ClusterImagePolicy)
}