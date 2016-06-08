

#import "MMDrawerController+Storyboard.h"
#import "MMDrawerController.h"

// custom placeholder segue
@interface MMDrawerControllerSegue : UIStoryboardSegue
@end

@implementation MMDrawerControllerSegue
-(void)perform
{
    // noop
    
    NSAssert( [self.sourceViewController isKindOfClass: [MMDrawerController class]], @"MMDrawerControllerSegue only to be used to define left/center/right controllers for a MMDrawerController!");
}
@end

@implementation MMDrawerController (Storyboard)

-(void)awakeFromNib
{
    // If we were instantiated via a storybard then we'll assume that we have pre-defined segues to denote
    // our center controller, and optionally left and right controllers!
    if ( self.storyboard != nil )
    {
        // Required segue "mm_center".  Uncaught exception if undefined in storyboard.
        [self performSegueWithIdentifier: @"mm_center" sender: self];

        // Optional segue "mm_left".
        @try
        {
            [self performSegueWithIdentifier: @"mm_left" sender: self];
        }
        @catch (NSException *exception)
        {
        }
        @finally
        {
        }
        
        // Optional segue "mm_right".
        @try
        {
            [self performSegueWithIdentifier: @"mm_right" sender: self];
        }
        @catch (NSException *exception)
        {
        }
        @finally
        {
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString: @"mm_center"] )
    {
        NSParameterAssert( [segue isKindOfClass: [MMDrawerControllerSegue class]]);
        [self setCenterViewController: segue.destinationViewController];
    }
    else
    if ( [segue.identifier isEqualToString: @"mm_left"] )
    {
        NSParameterAssert( [segue isKindOfClass: [MMDrawerControllerSegue class]]);
        [self setLeftDrawerViewController: segue.destinationViewController];
    }
    else 
    if ( [segue.identifier isEqualToString: @"mm_right"] )
    {
        NSParameterAssert( [segue isKindOfClass: [MMDrawerControllerSegue class]]);
        [self setRightDrawerViewController: segue.destinationViewController];
    }
}

@end
