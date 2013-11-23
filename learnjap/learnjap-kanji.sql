-- learnjap-kanji.sql --- regenerate learnjap-kanji-table.el
--
-- Use this SQL script if you wish to update learnjap-kanji-table.el to
-- newer versions of the unihan sqlite database, available at
-- http://code.google.com/p/unihan-sqlite-3-database
--
-- How to use it: run the script using the sqlite shell:
-- $ sqlite3 unihandbfilename.sqlite ".read learnjap-kanji.sql"
--
-- Copyright: Andrea Rossetti, 2013
--            http://thesoftwarebin.github.com
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--  
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--  
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

drop view v_temporary_kanji_info;

create view v_temporary_kanji_info as
  select
   u.code as "Code",
   '"'||u.utf8||'"' as "UTF8",
   '('||coalesce((select group_concat('"'||kJapaneseOn||'"',  ' ') from kJapaneseOnTable  where code=u.code), '""')||')' as "OnReadings",
   '('||coalesce((select group_concat('"'||kJapaneseKun||'"', ' ') from kJapaneseKunTable where code=u.code), '""')||')' as "KunReadings",
        coalesce((select '"'||kDefinition||'"' from kDefinitionTable  where code=u.code), '""')                          as "Definition",
        coalesce((select radicalIndex from kRSJapaneseTable where code=u.code)                              , 'nil')     as "RadicalIndex",
        coalesce((select kTotalStrokes from kTotalStrokesTable where code=u.code)                           , 'nil')     as "StrokeCount"
  from utf8Table u
  where (
    exists (select 1 from kJapaneseOnTable where code=u.code)
    or exists (select 1 from kJapaneseKunTable where code=u.code)
  );


.headers off

.output learnjap-kanji-table.el

select ';;; learnjap-kanji-table.el --- information for every Japanese kanji'; 
select '                                                                  '; 
select ';; This data has been extracted from the UniHan sqlite database   '; 
select ';; available at http://code.google.com/p/unihan-sqlite-3-database/'; 
select ';; using the script `learnjap-kanji.sql''.                         '; 
select ';; That database is released under GNU GPL v2.                    '; 
select '';

select '(defvar learnjap/kanjitable)';
select '';

select 
'(puthash '||code||' ''('
||' :utf8 '||UTF8
||' :onreadings '||OnReadings
||' :kunreadings '||KunReadings
||' :definition '||Definition
||' :strokecount '||StrokeCount 
||') learnjap/kanjitable)'
as result
from v_temporary_kanji_info;

.output stdout

drop view v_temporary_kanji_info;

