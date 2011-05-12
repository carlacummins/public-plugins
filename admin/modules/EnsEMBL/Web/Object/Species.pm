package EnsEMBL::Web::Object::Species;

use strict;

use base qw(EnsEMBL::Web::Object::DbFrontend);

### ### ### ### ### ### ### ### ###
### Inherited method overriding ###
### ### ### ### ### ### ### ### ###

sub manager_class {
  ## @overrides
  return shift->rose_manager('Species');
}

sub show_fields {
  ## @overrides
  my $self = shift;
  return [
    web_name          => {
      'type'      => 'string',
      'label'     => 'Name on website'
    },
    db_name           => {
      'type'      => 'string',
      'label'     => 'Name in database',
    },
    common_name       => {
      'type'      => 'string',
      'label'     => 'Common Name',
    },
    created_by_user   => {
      'type'      => 'noedit',
      'label'     => 'Created by'
    },
    created_at        => {
      'type'      => 'noedit',
      'label'     => 'Created at'
    },
    modified_by_user  => {
      'type'      => 'noedit',
      'label'     => 'Modified by'
    },
    modified_at       => {
      'type'      => 'noedit',
      'label'     => 'Modified at'
    },
  ];
}

sub show_columns {
  ## @overrides
  return [
    web_name    => 'Name (web)',
    db_name     => 'Name (db)',
    common_name => 'Name (common)'
  ];
}

sub record_name {
  ## @overrides
  return {
    'singular' => 'species',
    'plural'   => 'species'
  };
}

sub permit_delete {
  ## @overrides
  ## Record can not be deleted, but can be set inactive
  return 'retire';
}

sub page_type {
  ## @overrides
  return 'modal';
}

1;
