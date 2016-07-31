# Puppet Master configuration
class pe_bootstrap::master (
  Array[String,1] $hierarchy   = [
    'nodes/%{clientcert}',
    'roles/%{role}',
    'locations/%{location}',
    'tiers/%{tier}',
    'common/global',
  ],
  String          $datadir     = "${::settings::codedir}/environments/%{environment}/hieradata",
  Boolean         $create_keys = true,
) {

  class { '::hiera':
    owner          => 'pe-puppet',
    group          => 'pe-puppet',
    hierarchy      => $hierarchy,
    datadir        => $datadir,
    hiera_yaml     => "${::settings::confdir}/hiera.yaml",
    keysdir        => "${::settings::confdir}/keys",
    merge_behavior => 'deeper',
    eyaml          => true,
    create_keys    => $create_keys,
  }

  # Package creates user and group
  Package <| title == 'pe-puppetserver' |> -> Class['hiera']
}
