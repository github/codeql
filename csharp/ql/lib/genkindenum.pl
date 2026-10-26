#! /usr/bin/perl

# The C# extractor is developed on Windows, so output Windows line endings.
$\="\r\n";

($entity,$extension) = @ARGV;
if ($extension eq "")
{
	$extension = "_" . $entity;
}

$enumname = $entity;
$enumname =~ s/^(\w)/uc($1)/e;
$enumname =~ s/_(\w)/uc($1)/e;

print "namespace Semmle.Extraction.Kinds";
print "{";
print "	/// <summary>";
print "	/// This enum has been auto-generated from the C# DB scheme - do not edit.";
print "	/// Auto-generate command: `genkindenum.pl " . $entity . "`";
print "	/// </summary>";
print "	public enum " . $enumname . "Kind";
print "	{";

open FILE, "semmlecode.csharp.dbscheme" or die $!;

while (<FILE>)
{
	if ((/\b${entity}.kind/ .. /;/) && /\=/)
	{
		s/${extension}\b//;
		s/^\s*\|?\s*(\d+)\s*=\s*@(\w+).*/"\t\t" . uc($2) . " = " . $1 . ","/se;
		print;
	}
}

close FILE or die $!;

print "	}";
print "}";
