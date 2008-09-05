module RGitHook
  HTML_HEADER=<<-END
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html;" charset="utf-8"/>
<style>
    .commit dl { border: 1px #006 solid; background: #369; padding: 6px; color: #fff; }
    .commit dt { float: left; width: 6em; font-weight: bold; }
    .commit dt:after { content:':';}
    .commit dl, .commit dt, .commit ul, .commit li, #header, #footer { font-family: verdana,arial,helvetica,sans-serif; font-size: 10pt;  }
    .commit dl a { font-weight: bold}
    .commit dl a:link    { color:#fc3; }
    .commit dl a:active  { color:#ff0; }
    .commit dl a:visited { color:#cc6; }
    h3 { font-family: verdana,arial,helvetica,sans-serif; font-size: 10pt; font-weight: bold; }
    .commit pre { overflow: auto; background: #ffc; border: 1px #fc0 solid; padding: 6px; }
    .commit ul, pre { overflow: auto; }
    #header, #footer { color: #fff; background: #636; border: 1px #300 solid; padding: 6px; }
    .diff { width: 100%; }
    .diff h4 {font-family: verdana,arial,helvetica,sans-serif;font-size:10pt;padding:8px;background:#369;color:#fff;margin:0;}
    .diff .propset h4, .diff .binary h4 {margin:0;}
    .diff pre {padding:0;line-height:1.2em;margin:0;}
    .diff .diff {width:100%;background:#eee;padding: 0 0 10px 0;overflow:auto;}
    .diff .propset .diff, .diff .binary .diff  {padding:10px 0;}
    .diff span {display:block;padding:0 10px;}
    .diff .modfile, .diff .addfile, .diff .delfile, .diff .propset, .diff .binary, .diff .copfile {border:1px solid #ccc;margin:10px 0;}
    .diff ins {background:#dfd;text-decoration:none;display:block;padding:0 10px;}
    .diff del {background:#fdd;text-decoration:none;display:block;padding:0 10px;}
    .diff .lines, .info {color:#888;background:#fff;}
    .filename, .insertions, .deletions {display: inline;}
    .file {margin: 5px 0px 10px 20px}
    .filename {font-weight: bolder;}
    .insertions {color: green;}
    .deletions  {color: red;}
    .summary {border: 1px #006 solid; padding: 6px;}
    .summary li {list-style-type: none; margin: 0;padding: 0; font-size: 90%}
    .summary .file {color: #444;font-size: 0.9em; padding-left: 20px;}
    .summary ul {margin: 0; padding: 0;line-height:1.0em}
    .summary ul ul {margin: 0px 0px 10px 0px;}
</style>
</head>
<body>
END

  HTML_FOOTER=<<-END
    </body>
    </html>
  END



end
