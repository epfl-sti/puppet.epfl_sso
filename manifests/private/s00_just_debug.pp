

# Example: to make sure that your ssh server does not allow password-based user login:
# then top add a line in that file : ssh/sshd_config

class epfl_sso::private::s00_just_debug {



  #   log_levels.pp

  node default {


    notice  ('try to run this script with -v and -d to see difference between log levels')
    notice  ('function documentation is available here: http://docs.puppetlabs.com/references/latest/function.html')
    notice  ('--------------------------------------------------------------------------')

    debug   ('this is debug. visible only with -d or --debug')
    info    ('this is info. visible only with -v or --verbose or -d or --debug')
    alert   ('this is alert. always visible')
    crit    ('this is crit. always visible')
    emerg   ('this is emerg. always visible')
    err     ('this is err. always visible')
    warning ('and this is warning. always visible')
    notice  ('this is notice. always visible')
    #fail will break execution
    fail    ('this is fail. always visible. fail will break execution process')

              }

  }
