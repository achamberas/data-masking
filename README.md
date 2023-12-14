# Obfuscation of Data Files

This project is about X because of Y

## Prerequisite

In order to run this project you'll need to isntall these libraries:
* `openpyxl`
* `anonympy`
* `xlrd` (version > 1.0.0)
* `cape-privacy`

Here's a command that will install the dependencies (this is using python's pip package manager but conda should work as well):
```
pip install openpyxl anonympy xlrd>=1.0.0 cape-privacy
```

Also this project requires the folder structure below

```
├── root # this is a variable and has to be set in `Data Masking.ipynb` notebook
│   ├── Input_Files
│   ├── Output_Files/
```

## Data Masking Process - High Level

1. Get list of files that need to be masked
2. Manually add extra columns required for processing fields (ie `header_row,parent_folder,child_folder,skip,notes`)
3. Go through each file and compile a list of fields to be masked
4. Store this list in a google sheet
5. Go trhough those files, mask the fields using `anonympy` library, and save results of masked files to a specific folder on the local machine. 

## 





## Old Version Of Read Me

## Masking Data

To mask data that already exist in data files, open the `Data Masking.ipynb` notebook.  

#### install libraries
The notebook uses various libraries for masking data, so please install install them:

```
pip install openpyxl anonympy xlrd>=1.0.0
pip install cape-privacy --no-deps
```

#### set variables

set the `root` and `gsheet_id` variables to local directory of the data files and id of the public Google sheet `data_files.gsheet`, respectively.

#### obtain meta data from data files

Execute the code that scans the directory containing the data files.  This code will create a dataframe of all the files in the `root` directory along with files found in any subdirectories. 

This dataframe will then be written to the bottom of the `files` tab in the `data_files` Google sheet.  The appended rows will contain:

* object: the type of data stored in the file (membership, claims, etc.), read from the directory name representing the object.
* customer: the customer name as read from the directory name representing the customer
* file: the name of the data file
* encr: whether or not the file is encrypted
* file_type: the file type as read by the file extension (csv, xlsx, txt, etc)

#### modify and enhance file list

In the `file` tab of the  `data_files` Google sheet, delete any duplicate rows from previously appended records, and add values to the following columns:

* delimiter: 
    * character delimiters: the character used to delimit columns in text and csv files.  Options are: `comma`, `pipe` or `tab`
    * fixed with: provide a json object with the following keys `width` and `label`.  `width` is an array of integers representing the character width of each column.  `label` is an array of strings representing the label for each column.  For example:
            ```
            {"widths":[5,8], "labels":["column1", "column2"]}
            ```
    * Excel: delimiter is not necessary
* sheet_name: for Excel file, provide the tab number to 
* sheet_id
* header_row
* mapped_customer
* skip
* notes
>>>>>>> main
