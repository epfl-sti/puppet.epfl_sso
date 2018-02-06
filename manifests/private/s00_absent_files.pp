#  class epfl_sso::private::s00_class_absent_files

# s03     : /etc/network/interfaces
# s04     : /etc/hosts
# s05A    : /etc/resolv.conf
# s05B    : /etc/NetworkManager/NetworkManager
#   check a service : systemctl restart network-manager.service
# s06     : /etc/ntp.conf
# s09     : /etc/realmd.conf
# s10     : /etc/idmapd.conf
# s10     : /etc/krb5.conf
# s12     : /etc/samba/smb.conf
# s13     : /etc/sssd/sssd.conf
# s14     : /etc/nsswitch.conf
# s19     : /etc/pam.d/common-session
# s21     : /etc/default/nfs-common
# s26     : /etc/fstab
# s29     : /etc/ldap/ldap.conf
# s31     : /etc/autofs_ldap_auth.conf
# s32     : /etc/autofs.conf
# s33     : /etc/auto.master
# s35     : /etc/nsswitch.conf
# s36     : /etc/default/autofs
# s37     : //etc/sssd/sssd.conf

# class epfl_sso::private::params {

class epfl_sso::private::s00_absent_files {

  file { '/etc/network/interfaces':
    ensure  => 'present',
    replace => 'no', # this is the important property
    content => "From Puppet\n",
    mode    => '0644',
  }

  file { '/etc/hosts':
      ensure  => 'present',
      replace => 'no', # this is the important property
      content => "From Puppet\n",
      mode    => '0644',
    }
  file { '/etc/resolv.conf':
      ensure  => 'present',
      replace => 'no', # this is the important property
      content => "From Puppet\n",
      mode    => '0644',
    }

  file { '/etc/NetworkManager/NetworkManager':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s06     : /etc/ntp.conf
  file { '/etc/back-ntp.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s09     : /etc/realmd.conf
  file { '/etc/realmd.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s10     : /etc/idmapd.conf
  file { '/etc/bak-idmapd.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s10     : /etc/krb5.conf
  file { '/etc/bak-krb5.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s12     : /etc/samba/smb.conf
  file { '/etc/samba/smb.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s13     : /etc/sssd/sssd.conf
  file { '/etc/sssd/bak-sssd.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s14     : /etc/nsswitch.conf
      file { '/etc/bak-nsswitch.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s19     : /etc/pam.d/common-session
      file { '/etc/pam.d/common-session':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s21     : /etc/default/nfs-common
  file { '/etc/default/bak-nfs-common':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s26     : /etc/fstab
  file { '/etc/fstab':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s29     : /etc/ldap/ldap.conf
  file { '/etc/ldap/bak-ldap.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s31     : /etc/autofs_ldap_auth.conf
  file { '/etc/bak-autofs_ldap_auth.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s32     : /etc/autofs.conf
  file { '/etc/bak-autofs.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s33     : /etc/auto.master
  file { '/etc/bak-auto.master':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s35     : /etc/nsswitch.conf
  file { '/etc/bak2-nsswitch.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s36     : /etc/default/autofs
  file { '/etc/default/autofs':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
      # s37     : /etc/sssd/sssd.conf
  file { '/etc/sssd/bak2-sssd.conf':
        ensure  => 'present',
        replace => 'no', # this is the important property
        content => "From Puppet\n",
        mode    => '0644',
      }
}
