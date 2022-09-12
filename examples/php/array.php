<?php

$csv = "1,2,3
4,5,6
7,8,9";

$rows = explode("\n", $csv);

foreach ($rows as $k => $v) {
    $rows [$k] = explode(',', $v);
}

print_r($rows);
print_r(array_map('array_flip', $rows));