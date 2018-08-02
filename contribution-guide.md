# Contribution guide

### Pull requests
Help us improve! Pull requests are welcome.

### Uploading data to GCP bucket

All the data is hosted on the Google Cloud Platform (GCP) bucket (`gs://twsg-data-eng-bootcamp-data`) on a GCP project (`twsg-data-eng-bootcamp`).

To upload data:
- install `gcloud` CLI:
  - `curl https://sdk.cloud.google.com | bash`
  - `export PATH=$HOME/google-cloud-sdk/bin:$PATH`
- ask the bootcamp organizers to add you to the `twsg-data-eng-bootcamp` project on GCP
- Create a service account on the GCP project and download credentials
  - `mv ~/Downloads/twsg-data-eng-bootcamp-8454edad5956.json twsg-data-eng-bootcamp.json`
- Activate service account
  - `gcloud config set project twsg-data-eng-bootcamp`
  - `gcloud config set account your_service_account_name@twsg-data-eng-bootcamp.iam.gserviceaccount.com`
  - `gcloud auth activate-service-account --key-file ./twsg-data-eng-bootcamp.json`
- Upload data
  - Upload a single file: `gsutil cp path/to/file gs://twsg-data-eng-bootcamp-data`
  - Upload a directory: `gsutil cp -r path/to/directory gs://twsg-data-eng-bootcamp-data`
- If you want to make data publicly accessible
  - `gsutil -m acl set -R -a public-read gs://twsg-data-eng-bootcamp-data/data/path/to/file`