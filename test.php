<?php

exec("docker run -v ~/Desktop/:/scratch imagemagick identify -verbose /scratch/test.jpg", $output, $return);

var_dump($output);
var_dump($return);