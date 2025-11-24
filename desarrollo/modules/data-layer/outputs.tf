output "bucket_names" {
  value = { for k, v in google_storage_bucket.rag_raw_docs : k => v.name }
}
