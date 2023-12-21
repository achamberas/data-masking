# Obfuscation of Data Files

Main purpose of this project is to crawl through files, detect all the fields in those files and mask appropriate fields.

## Prerequisite

In order to run this project you'll need to install these libraries:
* `openpyxl`
* `anonympy`
* `xlrd` (version > 1.0.0)
* `cape-privacy`

Here's a command that will install the dependencies (this is using python's pip package manager but conda should work as well):
```
pip install openpyxl anonympy xlrd>=1.0.0 cape-privacy
```

This project expects the folder structure below:

```
├── Input_Files/
├── Output_Files/
```

If your folders have a prefix (for example `Sample_`) you can specify that prefix in the `root` variable (in this instance `Input_Files` would become `Sample_Input_Files` because of the prefix).

The process also assumes you downloaded the files that you want to mask. Data that needs to be masked has to be put in the `Input_Files/` folder. Specifically you'll need to create a sub-folder within `Input_Files` that represents type of file (ie claims) and a folder within that sub-folder that represents customer name. Here's an example of how that might look like:

```
├── Input_Files/
|   ├── claims/
|   |   ├── nike/
|   |    |  ├── file_to_be_masked.txt
```

If the folders already exist from previous masking efforts, no need to recreate them, you can just put the file in the corresponding folder.

Notebook also assumes you have access to `data_files.xlsx` excel file that holds information about previous files that got masked and how they got masked.


## Data Masking Process - High Level

1. Look through all the files that exist in `Input_Files/` and find newly loaded files
2. Update `data_files.xlsx` with new files that need to be masked and any additional info needed about the files (ie what row to start on)
3. Go through each of the files and get all the relevant fields and field metadata (ie data type of the field)
4. Update `data_files.xlsx` with new fields from step #3 and determine what needs to be masked and how.
5. Mask the fields and store output in the appropriate folder.

## Data Masking Process Steps Explained In Detail

### Step 1 - Find Newly Loaded Files

The first thing that happens in the notebook (after installing packages) is that it looks through all of the files under `Input_Files` and compares it with the list in `data_files.xlsx`. Once the new files are found, it stores those in a data frame and writes that dataframe into `data_files.xlsx` to update the existing list of files. The dataframe that is written has these columns:
* `object` - from the folder structure, it represents what kind of a file is it (ie claims)
* `customer` - from the folder structure, it represents name of the cusomter
* `file` - name of the file
* `is_gpg` - if the file is encrypted or not
* `file_type_x` - type of the file
* `date_x` - timestamp


### Step 2 - Manually Editing data_files.xlsx

After that dataframe has been written to `data_files.xlsx` open the `files` sheet within it. For each of the new files populate these columns (where appropriate):
* `delimeter` - what kind of delimeter does the file use
* `sheet_name` - what sheet name is the code supposed to look for if the file is excel
* `sheet_id` - What the is the ID of the `sheet_name` (order of the sheet) if the file is excel
* `header_row` - which row is header row
* `parent_folder` - in which parent folder is the output file going to be stored (if the folder doesn't exist the code will create it)
* `child_folder` - in which child folder is the output file going to be stored (if the folder doesn't exist the code will create it)
* `skip` - is the file going to be skipped during masking process or not
* `notes` - any notes that you might have

### Step 3 - Find All The Fields In New Files

After `data_files.xlsx` has been manually edited, go back to the notebook and load the `data_files.xlsx` again with updated info. From there the code will go through all of the files and find all the fields witin those files. All of that info gets stored in a dataframe that holds all the metadata about those fields. The dataframe has these columns:
* `object` - from the folder structure, it represents what kind of a file is it (ie claims)
* `customer` - from the folder structure, it represents name of the cusomter
* `file` - name of the file
* `file_type` - type fo the file
* `sheet_id` - what sheet is the information on
* `field` - name of the field
* `type` - type of the field
* `sample` - sample value of the field

This gets stored in back to `data_files.xlsx` to `mapping rules` sheet.

### Step 4 - Manually Determine What Needs To Get Masked

 Open up `data_files.xlsx` and `mapping_rules` sheet. Populate these fields where appropriate: 

* `mask_method` 
    * This could be either: 
        * `categorical_fake` - creates a fake category
        * `categorical_tokenization` - it masks data in a way where it can be reverted to the original data point. Also if the same value of the field shows up somewhere else it will use the same value, so merging data is easier
        * `categorical_resampling` - randomly sample from the original population and assign values 
* `mask_type`
    * if using `categorical_fake`, determine what kind of category are you faking (ie first name would be `first_name`. More info can on available categories can be found [here](https://arc.net/l/quote/szfjtfmf))

If the field does not have `mask_method` & `mask_type` values it will _not_ be masked.

### Step 5 - Mask The Data

After the `data_files.xlsx` has been manually edited, load it back in and mask each of the fields based on the paramaters specificed in the previouis step. After the data is masked it will be stored in the specified output folders.

Optional step: Preview the data thats masked & stored. 