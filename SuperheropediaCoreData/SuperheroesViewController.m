//
//  ViewController.m
//  SuperheropediaCoreData
//
//  Created by Ben Bueltmann on 3/25/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "SuperheroesViewController.h"
#import "AppDelegate.h"
#import "RetiredSuperhero.h"
#import "Superhero.h"


@interface SuperheroesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *heroes;
@property NSArray *retiredSuperheroes;
@property NSManagedObjectContext *moc;
@end

@implementation SuperheroesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;
    [RetiredSuperhero retrieveSuperheroesWithCompletion:^(NSArray *retiredSuperheroes) {
        self.retiredSuperheroes = retiredSuperheroes;
        [self populateWithRetiredHeroesIfEmpty];
    }];
    [self load];
}

-(void)setHeroes:(NSMutableArray *)heroes{
    _heroes = heroes;
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.heroes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuperheroesID"];
    Superhero *superhero = [self.heroes objectAtIndex:indexPath.row];

    cell.textLabel.text = superhero.name;
    cell.detailTextLabel.text = superhero.textDescription;
    cell.detailTextLabel.numberOfLines = 2;

//    [superhero getImageWithCompletion:^(NSData *data) {
//        if (data) {
//            cell.imageView.image = [UIImage imageWithData:data];
//        } else {
//            cell.imageView.image = [UIImage imageNamed:@"superdave"];
//        }
//        [cell layoutSubviews];
//    }];

    return cell;
}

-(void)load{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Superhero"];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDescriptor1];
    self.heroes = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

- (IBAction)onAddButtonPressed:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"New Superhero" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Description";
    }];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UITextField *nameTextField = [[alertController textFields] firstObject];
        UITextField *secondTextField = [[alertController textFields] lastObject];
        
        NSString *enteredName = nameTextField.text;
        NSString *enteredDescription = secondTextField.text;
        
        NSManagedObject *superhero = [NSEntityDescription insertNewObjectForEntityForName:@"Superhero" inManagedObjectContext:
                                      self.moc];
        [superhero setValue:enteredDescription forKey:@"textDescription"];
        [superhero setValue:enteredName forKey:@"name"];
        [self.moc save:nil];
        [self load];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)populateWithRetiredHeroesIfEmpty
{
    if (self.heroes.count < 2) {
        for (RetiredSuperhero *retiredSuperhero in self.retiredSuperheroes) {
            NSManagedObject *superhero = [NSEntityDescription insertNewObjectForEntityForName:@"Superhero" inManagedObjectContext:self.moc];
            [superhero setValue:retiredSuperhero.name forKey:@"name"];
            [superhero setValue:retiredSuperhero.textDescription forKey:@"textDescription"];
            [superhero setValue:retiredSuperhero.urlString forKey:@"imageURL"];
            [self.moc save:nil];
            [self load];
        }
    }
}


@end
