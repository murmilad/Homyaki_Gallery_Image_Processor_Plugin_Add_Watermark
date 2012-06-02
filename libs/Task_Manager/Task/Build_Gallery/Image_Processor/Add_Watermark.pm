package Homyaki::Task_Manager::Task::Build_Gallery::Image_Processor::Add_Watermark;

use strict;

use Imager;

use Homyaki::Imager qw(put_watermark);
use Homyaki::Logger;

use constant WATERMARK_PATH       => 'sign.bmp';

use base 'Homyaki::Task_Manager::Task::Build_Gallery::Image_Processor';

sub new {
	my $class = shift;
	my %h = @_;

	my $params = $h{params};

	my $self = $class->SUPER::new(
		params => $params
	);

	$self->{watermark_image} = $self->get_watermark_image();

	return $self;
}

sub process {
	my $self = shift;

	my %h = @_;
	my $image = $h{image};
	my $dest_path    = $h{dest_path};
	my $source_path  = $h{source_path};
	my $result_image = $h{result_image};

	my $fullpic = put_watermark($result_image, $self->{watermark_image});

	unless ($fullpic->write(file=>$dest_path->{pic})) {
		Homyaki::Logger::print_log("Build_Gallery: load_images: Error: ($dest_path)" . $fullpic->errstr());
		print STDERR "$dest_path->{pic} - ",$fullpic->errstr(),"\n";
	}
	
	return $fullpic;
}

sub get_watermark_image{
	my $self = shift;

	my $watermark_image;

	my $watermark_path = $self->{gallery_path} . &WATERMARK_PATH;

	if (-f $watermark_path){
		$watermark_image = Imager->new();
		unless ($watermark_image->open(file => $watermark_path)) {
			print STDERR "$watermark_path - ",$watermark_image->errstr(),"\n";
			Homyaki::Logger::print_log("Build_Gallery: Get Watermark: Error: ($watermark_path) ". $watermark_image->errstr());
		}
	}

	return $watermark_image;
}

1;
