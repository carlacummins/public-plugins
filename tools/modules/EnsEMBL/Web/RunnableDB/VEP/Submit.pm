=head1 LICENSE

Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::Web::RunnableDB::VEP::Submit;

### Hive Process RunnableDB for VEP

use strict;
use warnings;

use base qw(EnsEMBL::Web::RunnableDB);

use EnsEMBL::Web::Exceptions;
use EnsEMBL::Web::SystemCommand;
use EnsEMBL::Web::Tools::FileHandler qw(file_get_contents);

sub run {
  my $self = shift;

  my $perl_bin  = $self->param('perl_bin');
  my $script    = $self->param('script');
  my $cache_dir = $self->param('cache_dir');
  my $work_dir  = $self->param('work_dir');
  my $config    = $self->param('config');
  my $log_file  = "$work_dir/lsf_log.txt";

  my $options   = {
    '--force'       => '',
    '--quiet'       => '',
    '--vcf'         => '',
    '--tabix'       => '',
    '--fork'        => 4,
    '--stats_text'  => '',
    '--dir'         => $cache_dir,
    '--cache'       => ''
  };

  $options->{"--$_"} = sprintf '%s/%s', $work_dir, delete $config->{$_} for qw(input_file output_file stats_file);
  $options->{"--$_"} = $config->{$_} eq 'yes' ? '' : $config->{$_} if defined $config->{$_} && $config->{$_} ne 'no';

  my $command = EnsEMBL::Web::SystemCommand->new($self, "$perl_bin $script", $options)->execute({'log_file' => $log_file});

  return unless $command->error_code;

  throw exception('HiveException', join('', file_get_contents($log_file)));
}

1;
