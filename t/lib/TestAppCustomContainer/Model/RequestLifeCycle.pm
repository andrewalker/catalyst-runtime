package TestAppCustomContainer::Model::RequestLifeCycle;
use Moose;
extends 'Catalyst::Model';
with 'TestAppCustomContainer::Role::ACCEPT_CONTEXT';

__PACKAGE__->meta->make_immutable;

no Moose;
1;
