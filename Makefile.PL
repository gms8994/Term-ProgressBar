use 5.005;
use strict;

use File::Spec qw( );
sub catfile { File::Spec->catfile(@_) }

use constant MOD_REQS =>
  [
   { name    => 'Class::MethodMaker',
     package => 'Class-MethodMaker',
     version => '1.02', },

   { name    => 'Term::ReadKey',
     package => 'TermReadKey',
     version => '2.14',
   },
  ];

use constant EXEC_REQS =>
  [
  ];

use constant NAME         => 'Term-ProgressBar';
use constant VERSION_FROM => catfile (qw( lib Term ProgressBar.pm ));
use constant AUTHOR       => 'Martyn J. Pearce fluffy@cpan.org';
use constant ABSTRACT     => 'Progress bar for things that take a while';

use FindBin 1.42 qw( $Bin );
use lib $Bin;
use make;
