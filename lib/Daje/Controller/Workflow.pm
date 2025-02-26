package Daje::Controller::Workflow;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use v5.40;

# NAME
# ====
#
# Daje::Controller::Workflow - It's new $module
#
# SYNOPSIS
# ========
#
#     use Daje::Controller::Workflow;
#
# DESCRIPTION
# ===========
#
# Daje::Controller::Workflow is ...
#
# LICENSE
# =======
#
# Copyright (C) janeskil1525.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# AUTHOR
# ======
#
# janeskil1525 E<lt>janeskil1525@gmail.comE<gt>
#
#

use Mojo::JSON qw{decode_json};

our $VERSION = "0.02";


sub execute($self) {

    my $test = 1;
    # $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $data->{data} = decode_json ($self->req->body);
    $data->{users_fkey} = $users_pkey;
    $data->{companies_fkey} = $companies_pkey;
    $data->{data}->{workflow}->{workflow_pkey} = 0 unless $data->{workflow}->{workflow_pkey};
    #
    # push @{$data->{actions}}, "$self->stash('wf_action')";
    # $data->{workflow}->{workflow} = $self->stash('workflow');
    # $data->{workflow}->{workflow_relation} = $self->stash('workflow_relation');
    # $data->{workflow}->{workflow_relation_key} = $self->stash('workflow_relation_key');
    # $data->{workflow}->{workflow_origin_key} = $self->stash('workflow_origin_key');
    #
    # say Dumper ($data);
    try {
        $self->workflow->workflow_pkey($data->{data}->{workflow}->{workflow_pkey});
        $self->workflow->workflow_name($data->{data}->{workflow}->{workflow});
        $self->workflow->context($data);

        $self->workflow->process($data->{data}->{workflow}->{activity});
        if($self->workflow->error->has_error() == 0) {
            $self->render(json => {'result' => 'success'});
        } else {
            $self->render(json =>
                {'result' => 'failed', data => $self->workflow->error->error()}
            );
        }
    } catch ($e) {
        $self->render(json => {'result' => 'failed', data => $e});
    };
}
1;
__END__




#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME


Daje::Controller::Workflow - It's new $module



=head1 SYNOPSIS


    use Daje::Controller::Workflow;



=head1 DESCRIPTION


Daje::Controller::Workflow is ...



=head1 REQUIRES

L<Mojo::Base> 


=head1 METHODS

=head2 execute($self)

 execute($self)();


=head1 AUTHOR


janeskil1525 E<lt>janeskil1525@gmail.comE<gt>




=head1 LICENSE


Copyright (C) janeskil1525.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.



=cut

