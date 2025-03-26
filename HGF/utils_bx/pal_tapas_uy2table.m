function T = uy2table(tapas_struct, varargin)
    % Convert tapas output structure to table with optional identifier columns
    %
    % maybe we can extend this to traj variables!
    %
    % Inputs:
    %   tapas_struct        - Structure containing y and u fields
    %   varargin   - Name-value pairs for additional columns
    %               Format: 'ColumnName', value
    %               Example: 'ID', ones(length(est.y), 1)
    %
    % Output:
    %   T          - Table containing y, u and any additional columns
    %
    % Example:
    %   T = estToTable(est)  % Basic usage
    %   T = estToTable(est, 'ID', ones(400,1), 'Group', 'A'*ones(400,1))
    
    % Input validation
    if ~isstruct(tapas_struct) || ~isfield(tapas_struct, 'y') || ~isfield(tapas_struct, 'u')
        disp('Warning: input is not a structure with fields y and u; empty table returned');%why was warning turned off??

        
        % Create empty table with correct structure
        % Calculate number of additional columns from varargin
        n_additional_cols = floor(length(varargin)/2);  % Each additional column needs name-value pair
        
        % Create variable names array - additional columns first, then y and u
        varNames = cell(1, n_additional_cols + 2);
        for i = 1:n_additional_cols
            varNames{i} = varargin{2*i-1};  % Get column names from odd indices of varargin
        end
        varNames(end-1:end) = {'y', 'u'};
        
        % Create empty table with correct variable names
        T = array2table(zeros(0, length(varNames)), 'VariableNames', varNames);
        return
    end
        
    % Initialize the table with y and u
    T = table(tapas_struct.y, tapas_struct.u, 'VariableNames', {'y', 'u'});
    
    % Process additional columns if provided
    if nargin > 1
        % Check if number of additional arguments is even
        if mod(length(varargin), 2) ~= 0
            error('Additional arguments must be provided as name-value pairs');
        end
        
        % Add each additional column
        for i = 1:2:length(varargin)
            colName = varargin{i};
            colValue = varargin{i+1};
            
            % If the value is not a cell array and is a single value,
            % replicate it to match the length of y
            if ~iscell(colValue) && length(colValue) == 1
                colValue = repmat(colValue, length(tapas_struct.y), 1);
            end
            
            % Validate the length of the column
            if length(colValue) ~= length(tapas_struct.y)
                error('Column %s must have the same length as y and u', colName);
            end
            
            % Add the column to the table before y and u
            T = addvars(T, colValue, 'Before', 'y', 'NewVariableNames', colName);
        end
    end
end