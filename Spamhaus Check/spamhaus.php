<?php
/*
Simple Nagios plugin to detect if Spamhaus has blacklisted an IP
 */

//Pass in the IP to check from Nagios as $ARG1$
$ip = $argv[1];

$SpamHaus = checkSpamhaus($ip);

if ($SpamHaus === TRUE){
        echo "Spamhaus has blacklisted the IP {$ip} - Request removal at: https://www.spamhaus.org/pbl/removal/";
        exit(2);
}else{
        echo "OK - IP {$ip} is not blacklisted on Spamhaus";
        exit(0);
}

function checkSpamhaus($ip) {
    $blacklist = "zen.spamhaus.org";
    $url = implode(".", array_reverse(explode(".", $ip))) . ".". $blacklist;
    $record = dns_get_record($url);
    if (is_array($record) && !empty($record)) :
        return TRUE;
    endif;
}
