function modifiedArray = deleteFirstElementIfOne(inputArray)
    % ���������
    % inputArray: ������������������飩

    % ���ҵ�һ��Ԫ��Ϊ1������
    indexToRemove = find(inputArray == 1, 1);

    % ����ҵ��˵�һ��Ԫ��Ϊ1����������ɾ����Ԫ��
    if ~isempty(indexToRemove)
        modifiedArray = inputArray([1:indexToRemove-1, indexToRemove+1:end]);
    else
        modifiedArray = inputArray; % ���û���ҵ���ֱ�ӷ���ԭʼ����
    end
end