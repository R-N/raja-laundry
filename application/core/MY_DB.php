<?php

class MY_DB extends CI_DB {
    function mysqlToPostgres($query){
        if ($this->db->dbdriver !== "postgre")
            return $query;
        // Replace CURDATE() with CURRENT_DATE
        $query = preg_replace('/\bCURDATE\(\)/i', 'CURRENT_DATE', $query);
        // Replace INTERVAL X UNIT with INTERVAL 'X units', ensuring unit is plural
        $query = preg_replace_callback('/INTERVAL\s+(\d+)\s+(\w+)/i', function($matches) {
            $unit = strtolower($matches[2]);
            // Ensure unit is plural for PostgreSQL
            if (substr($unit, -1) !== 's') {
                $unit .= 's';
            }
            return "INTERVAL '{$matches[1]} $unit'";
        }, $query);

        //\"{$this->db->schema}\"
        $schema = $this->schema;  // Replace with your dynamic schema name


        // Step 1: Add schema name to tables in FROM, JOIN, LEFT JOIN, RIGHT JOIN clauses (only once per table name)
        //[\"?a-zA-Z0-9\-_,\.\s]
        
        $query = preg_replace_callback('/\b(FROM|JOIN|LEFT\s+JOIN|RIGHT\s+JOIN)\s+([\`\'\"a-zA-Z0-9\-_,\.\s]+?)(?=\s(ON|WHERE|HAVING|LIMIT|OFFSET|JOIN|LEFT\s+JOIN|RIGHT\s+JOIN)\s)/i', function($matches) use ($schema) {
            // Split comma-separated tables
            $tables = explode(',', $matches[2]);
            foreach ($tables as &$table) {
                // Trim spaces and add schema to each table name
                $table = trim($table);
                $table = '"' . $schema . '".' . $table;
            }
            $tables = implode(', ', $tables);
            return "{$matches[1]} \"{$schema}\".{$tables}";
        }, $query);

        // Step 2: Remove duplicate schema occurrences
        $query = str_replace("\"{$schema}\".\"{$schema}\"", "\"{$schema}\"", $query);
        $query = str_replace("\"{$schema}\".\"{$schema}\"", "\"{$schema}\"", $query);

        // Replace YEAR(<column>) with EXTRACT(YEAR FROM <column>)
        $query = preg_replace('/YEAR\(([^)]+)\)/i', 'EXTRACT(YEAR FROM $1)', $query);
        // Replace MONTH(<column>) with EXTRACT(MONTH FROM <column>)
        $query = preg_replace('/MONTH\(([^)]+)\)/i', 'EXTRACT(MONTH FROM $1)', $query);
        // Replace DAYNAME(<column>) with TO_CHAR(<column>, 'Day')
        $query = preg_replace('/DAYNAME\(([^)]+)\)/i', "TO_CHAR($1, 'Day')", $query);
        // Replace WEEKDAY(<column>) with EXTRACT(DOW FROM <column>)
        $query = preg_replace('/WEEKDAY\(([^)]+)\)/i', 'EXTRACT(DOW FROM $1)', $query);
        // Replace backticks
        $query = str_replace('`', '', $query);

        return $query;
    }

}