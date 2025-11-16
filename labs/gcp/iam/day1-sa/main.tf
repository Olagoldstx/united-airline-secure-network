
resource "google_service_account" "sa" {
  account_id   = "stc-iam-sa"
  display_name = "Secure The Cloud SA"
}
resource "google_project_iam_member" "viewer" {
  project = google_service_account.sa.project
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.sa.email}"
}
output "service_account_email" { value = google_service_account.sa.email }
