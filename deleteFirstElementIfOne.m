function modifiedArray = deleteFirstElementIfOne(inputArray)
    % 输入参数：
    % inputArray: 待处理的向量（或数组）

    % 查找第一个元素为1的索引
    indexToRemove = find(inputArray == 1, 1);

    % 如果找到了第一个元素为1的索引，则删除该元素
    if ~isempty(indexToRemove)
        modifiedArray = inputArray([1:indexToRemove-1, indexToRemove+1:end]);
    else
        modifiedArray = inputArray; % 如果没有找到，直接返回原始数组
    end
end