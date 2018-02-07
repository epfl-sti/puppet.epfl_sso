# puppet.epfl_sso
UNIX single sign-on using EPFL's LDAP and Kerberos servers

# Apply one-shot

[Install Puppet standalone](https://docs.puppetlabs.com/puppet/3.8/reference/pre_install.html#standalone-puppet) then, as *root*:

  1. `puppet module install epflsti-epfl_sso` # Install the module
  2. `puppet apply -e "class { 'quirks': }  class { 'quirks::pluginsync': }"` # Repeat if prompted to
  3. Then, apply the epfl_sso class:  <pre>
      puppet apply -e "class { 'epfl_sso':
          allowed_users_and_groups => 'user1 user2 (group1) (group2)',
          join_domain => 'OU=IEL-GE-Servers,OU=IEL-GE,OU=IEL,OU=STI',
          auth_source => 'AD',
          directory_source => 'AD'
      }"</pre>
</pre>

_Note:_ `user1` & `user2` are GASPAR usernames (or local account) and `group1` and `group2` are [EPFL groups](https://groups.epfl.ch) which are visible in ldap.epfl.ch, for example:  
`puppet apply -e "class { 'epfl_sso': allowed_users_and_groups => 'admin nborboen (stiitlinux)' }"`  
where `admin` is a local account, `nborboen` a GASPAR username and `stiitlinux` a EPFL group.

# All Parameters

[Documented here.](https://github.com/epfl-sti/puppet.epfl_sso/blob/master/manifests/init.pp#L7)

## Development

To work off the latest ("master") version of `epfl_sso`:

  1. Be sure to remove previous version: `puppet module uninstall epflsti-epfl_sso` (add `--ignore-changes` if needed)
  1. Go in the puppet folder: `cd /etc/puppet/code/modules` (your mileage may vary on different distributions)
  1. Remove `epfl_sso` (but it should have been done at step 1)
  1. Clone the repo here: `git clone https://github.com/epfl-sti/puppet.epfl_sso.git epfl_sso`
