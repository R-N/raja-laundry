<?php


function escape($search)
{
	$search = get_instance()->db->escape($search);
	$search = substr($search, 1, strlen($search)-2);
	return $search;
}

function validateUrl($url){
	if($url) return true;
	return false;
}

function print_r_reverse($in) {
  $lines = explode("\n", trim($in));
  if (trim($lines[0]) != 'Array' && trim($lines[0] != 'stdClass Object')) {
// bottomed out to something that isn't an array or object
    return $in;
  } else {
// this is an array or object, lets parse it
    $match = array();
    if (preg_match("/(\s{5,})\(/", $lines[1], $match)) {
// this is a tested array/recursive call to this function
// take a set of spaces off the beginning
      $spaces = $match[1];
      $spaces_length = strlen($spaces);
      $lines_total = count($lines);
      for ($i = 0; $i < $lines_total; $i++) {
        if (substr($lines[$i], 0, $spaces_length) == $spaces) {
          $lines[$i] = substr($lines[$i], $spaces_length);
        }
      }
    }
    $is_object = trim($lines[0]) == 'stdClass Object';
    array_shift($lines); // Array
    array_shift($lines); // (
    array_pop($lines); // )
    $in = implode("\n", $lines);
    $matches = array();
// make sure we only match stuff with 4 preceding spaces (stuff for this array and not a nested one)
    preg_match_all("/^\s{4}\[(.+?)\] \=\> /m", $in, $matches, PREG_OFFSET_CAPTURE | PREG_SET_ORDER);
    $pos = array();
    $previous_key = '';
    $in_length = strlen($in);
// store the following in $pos:
// array with key = key of the parsed array's item
// value = array(start position in $in, $end position in $in)
    foreach ($matches as $match) {
      $key = $match[1][0];
      $start = $match[0][1] + strlen($match[0][0]);
      $pos[$key] = array($start, $in_length);
      if ($previous_key != '') {
        $pos[$previous_key][1] = $match[0][1] - 1;
      }
      $previous_key = $key;
    }
    $ret = array();
    foreach ($pos as $key => $where) {
// recursively see if the parsed out value is an array too
      $ret[$key] = print_r_reverse(substr($in, $where[0], $where[1] - $where[0]));
    }
    return $is_object ? (object) $ret : $ret;
  }
}
