<?php
// assuming given input has always 1 solution so not returning any errors
function twoSum($arr, $target) {
    $len = count($arr);

    for ($i = 0; $i <= $len - 2; $i++) {

        for ($j = 0; $j <= $len - 1; $j++) {
            if ($i != $j) {

                if (($arr [$i] + $arr [$j]) == $target) {
                    return [$i, $j];
                }

            }

        }
    }

    return false;
}

print_r(twoSum(
    [1, 3, 4, 5, 6, 2], 3
));

print_r(twoSum(
    [1, 3, 4, 5, 6, 2], 9
));

print_r(twoSum(
    [1, 0, 2], 2
));

print_r(twoSum(
    [2, 0, 1], 2
));