//
//  TeamTableViewController.m
//  SuperheropediaCoreData
//
//  Created by Chee Vue on 6/3/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "TeamTableViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Team.h"
#import "Superhero.h"

@interface TeamTableViewController ()

@property NSManagedObjectContext *moc;
@property NSArray *teams;

@end

@implementation TeamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //UIApplication is a singleton class and sharedApplication is an instance of your app
    //only one app; grab the app delegate's moc; we setup to get the right type
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = appDelegate.managedObjectContext;

    [self loadTeams];

}

#pragma  mark - Custom Methods
-(void)loadTeams{

    //NSStringFromClass- return name of class as string; better way for autocomplete the class
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Team class])];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Team"];  -- alternative way

    //perform fetch and fill with teams (load into self.teams)
    self.teams = [self.moc executeFetchRequest:request error:nil]; //use moc object to execute it
    [self.tableView reloadData]; //when we modify table view's model, need to reload data

    Team *theTeamWeCareAbout = self.teams.firstObject;

    //find all super heroes in a team
    request = [NSFetchRequest fetchRequestWithEntityName:@"Superhero"];
    request.predicate = [NSPredicate predicateWithFormat:@"teams CONTAINS %@", theTeamWeCareAbout];
    NSArray *herosInTeam1 = [self.moc executeFetchRequest:request error:nil];
    
    //note that this is the same
    id easier = [[self.teams objectAtIndex:0] superheroes];
    
    //but sometimes your query is more complex, so you can't just do that e.g.
    request = [NSFetchRequest fetchRequestWithEntityName:@"Superhero"];
    request.predicate = [NSPredicate predicateWithFormat:@"teams CONTAINS %@", [self.teams.firstObject name]];
    NSArray *foo = [self.moc executeFetchRequest:request error:nil];

}
- (IBAction)onAddSuperhero:(UIBarButtonItem *)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Team *team = [self.teams objectAtIndex:indexPath.row];

    //instantiate a hero
    Superhero *hero = [NSEntityDescription insertNewObjectForEntityForName:@"Superhero" inManagedObjectContext:self.moc];
    hero.name = @[@"Max", @"Rich", @"Clint"][arc4random_uniform(3)]; //get random names
    [team addSuperheroesObject:hero]; //call team's addSuperheroesObject method to add a hero
    [self.moc save:nil];

    [self loadTeams];
}


- (IBAction)onAddTapped:(UIBarButtonItem *)sender {

    //UIAlertView is DEPRECATED in ios8; use UIAlertController!

    //Instantiate an AlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Superhero" message:nil preferredStyle:UIAlertControllerStyleAlert];

    //setup the 'Name' input textfield
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name"; //display string when no other text is in textfield
    }];

    //setup the 'Description' input textfield
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Description";
    }];

    //create "ADD" alert action
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

        UITextField *nameTextField = [[alertController textFields] firstObject];
//        UITextField *nameTextField = alertController.textFields.firstObject;
        UITextField *secondTextField = [[alertController textFields] lastObject];
//        UITextField *secondTextField = alertController.textFields.lastObject;

        NSString *enteredName = nameTextField.text;
        NSString *enteredDescription = secondTextField.text;

        NSManagedObject *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:
                                 self.moc];
        [team setValue:enteredDescription forKey:@"textDescription"];
        [team setValue:enteredName forKey:@"name"];
        [self.moc save:nil];
        [self loadTeams];
    }];

    //create "CANCEL" alert action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];

    //add 'ADD' and 'CANCEL' actions to alert controller
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];


    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return self.teams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Team *team = [self.teams objectAtIndex:indexPath.row];
    cell.textLabel.text = team.name;
    cell.detailTextLabel.text = @(team.superheroes.count).stringValue;


    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
