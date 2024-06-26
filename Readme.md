# Personal Package Collection

## Swift Package collection

You can use the collection with this url:
```
https://github.com/alexandre-pod/PersonalPackageCollection/releases/latest/download/collection.json
```

## Usage

### Requirements

- swift package collection certificate `spm_collection.cer` (from Apple developer site)
- swift package collection certificate private key in pem format `spm_collection.pem` (see how to get it from below)

To generate the private key file, add the private key (p12) of the swift package collection
certificate at `./spm_collection.p12`, next run those commands to convert it to the correct format:
```bash
openssl pkcs12 -in spm_collection.p12 -nocerts -noenc -legacy | sed -ne '/-BEGIN PRIVATE KEY-/,/-END PRIVATE KEY-/p' > spm_collection.pem
```

Signing the collection requires the entire chain of CA ([documentation](https://github.com/apple/swift-package-collection-generator/blob/main/Sources/PackageCollectionSigner/README.md)),
they had been downloaded from [https://www.apple.com/certificateauthority/](https://www.apple.com/certificateauthority/)
and depends of your Swift package collection certificate:
- `ca-intermediate`: Worldwide Developer Relations - G6
- `ca-root`: Apple Inc. Root

To know which intermediate certificate you must use, read the contents of your public certificate
```bash
openssl x509 -inform DER -text -noout -in spm_collection.cer
```
Here an output example that means you need to use the "G6" intermediate certificate
```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: CN=Apple Worldwide Developer Relations Certification Authority, OU=G6, O=Apple Inc., C=US
        Validity
            [...]
```

### Collection Generation

Once you created the files `spm_collection.pem`, `spm_collection.cer` and used the correct `ca-intermediate.cer` and `ca-root.cer`,
the collection can be generated and signed with this command:
```bash
./build_binaries.sh
./generate_collection.sh packages_list.json 1 spm_collection.pem spm_collection.cer collection.json
```

## Maintainer informations

Secrets needed for the GitHub auto release workflow:
- `PRIVATE_KEY_CONTENT`: the content of the certificate private key (spm_collection.pem)
- `CERTIFICATE_CONTENT_B64`: the base64 of the certificate (`base64 -i spm_collection.cer`)

The release workflow update the collection on every commit on master.
A new release is done by incrementing the last version tag, creating a new github release and
adding the json as an artifact to the release.
