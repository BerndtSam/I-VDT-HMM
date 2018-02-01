classdef DirectoryReader < handle
% This class implement advanced directory reader. It main purpose to remove
% the necessity to manually specify every input sacccads files  and output
% files with extracted parameters. Used in OPMM parameters extractor.
%
% Alex Karpov, ak26@txstate.edu, Texas State University, San Marcos

    methods(Static)
% This function return total number of files in the input directory. If
% directory doesn't exist the result should be zero.
        function result = TotalFiles( InputDirectory )
            result = 0;
% If provided directory doesn't exist we should return 0
            if( ~exist( InputDirectory, 'dir' ) ), return; end;
% Otherwise retrieve contents of the directory
            DirectoryList = dir( strcat( InputDirectory, '\*.*' ) );
            result = sum( 1 - [ DirectoryList(:).isdir ] );
        end
    end

    methods
% This function extract requested filename from input directory.
        function result = GetFileFromInputDirectory( obj, InputDirectory, FileNumber )
            result = '';
% If provided directory doesn't exist we should return empty string
            if( ~exist( InputDirectory, 'dir' ) ), return; end;
% If provided file number not a number of negative number or exceeds the
% total number of files in directory we also have to return empty string.
            if( ~isnumeric( FileNumber) ), return;
            elseif( FileNumber < 1 || FileNumber > obj.TotalFiles( InputDirectory ) ), return;
            end
% Otherwise retrieve contents of the directory
            DirectoryList = dir( strcat( InputDirectory, '\*.*' ) );
% Next we extract only files from the content of directory
            DirectoryList = { DirectoryList(  [ DirectoryList(:).isdir ] == 0  ).name };
            result = DirectoryList{FileNumber};
        end



% This function returns requested filename from input directory. File can
% be identified by its number. If this number is improper the result shoud
% be empty string.
        function result = InputFileName( obj, InputDirectory, FileNumber )
            result = '';
% Get filename from input directory
            FileName = obj.GetFileFromInputDirectory( InputDirectory, FileNumber );
% If filename is an empty string then we return
            if( strcmp( FileName, '' ) ), return; end
% Otherwise we create a full filename for input file
            result = strcat( InputDirectory, '\', FileName );
        end



% This function returns requested filename from output directory. File can
% be identified by its number. If this number is improper the result should
% be empty string.
        function result = OutputFileName ( obj, InputDirectory, OutputDirectory, FileNumber )
            result = '';
% If provided output directory doesn't exist we should return empty string
            if( ~exist( OutputDirectory, 'dir' ) ), return; end;
% Get filename from input directory
            FileName = obj.GetFileFromInputDirectory( InputDirectory, FileNumber );
% If filename is an empty string then we return
            if( strcmp( FileName, '' ) ), return; end
% Otherwise we create a full filename for input file
            result = strcat( OutputDirectory, '\', FileName );
        end


    end
    
end

