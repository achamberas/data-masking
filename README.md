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

This project requires the folder structure below:

```
├── root # this is a variable and has to be set in `Data Masking.ipynb` notebook
│   ├── Input_Files/
|   |    ├── object/
|   |    |   ├── customer_name/
│   ├── Output_Files/
```

`object` represents the type of a claim (folder name should not be `object` it should be the claim type, ie ADT). `customer_name` represents name of the customer (folder name should not be `customer_name` it should be the name of the customer, ie Nike).

Main notebook that needs to be run in order to mask data is `Data Masking.ipynb`

## Data Masking Process - High Level

1. Get list of files that need to be masked
2. Upload that list to google sheets and manually add extra columns required for processing fields (ie `header_row,parent_folder,child_folder,skip,notes`)
3. Go through each file and compile a list of fields to be masked
5. Go trhough those files, mask the fields using `anonympy` library, and save results of masked files to a specific folder on the local machine. 


## Data Masking Process Steps Explained In Detail

### Get list of files that need to be masked

Loop through all the files that are in `Input_Files/` folder and create a dataframe. Each row represents a file with these fields:
* `object` - type of data stored in the file (membership, claims, etc.). Obtained from folder structure
* `customer` - customer name obtained from the folder structure
* `file` - name of the file that's processed
* `is_gpg` - is file encrypted or not
* `file_type_x` - what type of the file is it (txt, xlsx etc.) 

Next step is manually adding columns.

### Manually add extra columns required for processing fields

Upload this to google sheets and add/update these columns:

* `encr` - is file enxrypted or not
* `delimeter` - what character delimeter was used
* `sheet_name` - what google sheet / excel file this is
* `sheet_id` - ID of the sheet
* `header_row` - what i sthe header row
* `parent_folder` - parent folder of the file
* `child_folder` - child folder of the file
* `skip` - should this row be skipped or not
* `notes` - any notes

### Go through each file and compile a list of fields to be masked

For each of the files compiled from the previous step, get all the fields that need to be masked. Output of this is a dataframe that has these columns:

* `object` - type of data stored in the file (membership, claims, etc.). Obtained from folder structure
* `customer` - customer name obtained from the folder structure
* `file` - name of the file that's processed
* `file_type` - what type of the file is it (txt, xlsx etc.) 
* `sheet_id` - ID of the sheet
* `field` - name of the field
* `type` - type of the field (datetime, int etc.)
* `sample` - sample value

### Mask fields using `anonympy`

From the dataframe obtained in the previous step, loop through all the fields, anonymyze appropriate fields and store compiled dataframe in `Output_Files/` folder.