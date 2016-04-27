class clamav {
  include clamav::install
  include clamav::service
  include clamav::config
  include clamav::unofficial
}
