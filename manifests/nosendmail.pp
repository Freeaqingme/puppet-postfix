class postfix::nosendmail {
    service { 'sendmail':
        ensure => stopped,
        enable => false,
        before => Service['postfix'],
    }

    # since 'enable => false' won't remove them from rc.conf
    # we'll do that ourselves
    # also, we need to stop other parts of sendmail as well
    file_line { "${module_name}-rc.conf-sendmail":
        ensure => present,
        path   => '/etc/rc.conf',
        line   => 'sendmail_enable="NO"',
    }

    file_line { "${module_name}-rc.conf-sendmail-submit":
        ensure => present,
        path   => '/etc/rc.conf',
        line   => 'sendmail_submit_enable="NO"',
    }

    file_line { "${module_name}-rc.conf-sendmail-outbound":
        ensure => present,
        path  => '/etc/rc.conf',
        line  => 'sendmail_outbount_enable="NO"',
    }

    file_line { "${module_name}-rc.conf-sendmail-msp-queue":
        ensure => present,
        path  => '/etc/rc.conf',
        line  => 'sendmail_msp_queue_enable="NO"',
    }

    # also, replace the system's mail configuration
    file { "${module_name}-mailer.conf":
        ensure => file,
        owner => 'root',
        group => 'wheel',
        mode => '0644',
        name => '/etc/mail/mailer.conf',
        source => "puppet:///modules/${module_name}/mailer.conf-freebsd",
        before => Service['postfix'],
    }
}
