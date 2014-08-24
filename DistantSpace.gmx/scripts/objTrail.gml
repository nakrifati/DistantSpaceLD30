image_alpha-=subtract;
if(image_alpha<0)
{
    instance_destroy();
}

image_speed=0;

image_xscale+=xGrow;
image_yscale+=yGrow;

image_xscale+=grow;
image_yscale+=grow;

image_angle+=turn;
