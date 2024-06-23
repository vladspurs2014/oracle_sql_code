CREATE TABLE AuditBudget ((
    ProjectNumber int NULL,
    UserName varchar(16) NULL,
    Date DATETIME NULL,
    BudgetOld int NULL,
    BudgetNew int NULL
);
go

create trigger dbo.trigger_ModifyBudget -- �������� �������� ����� ����������� create trigger. ��������� ������������ ������� � �����, � ������� ����� ��������� ������
on Project after update /* ���������, � ��������� ����� ������� ����� ������ �������. ����� ��������� ��� ��������: � ������ ������ ������������ ��� after. ������ ��� ������� ����������� ����� ��������,
������������ �������. �������� ��������, ���������� �������. ��� ����� ���� DML ��������. � ������ ������ ������� �������� - UPDATE */
as if update (budget) /* �������� ����������� ���� (����������) �������, ������� ���������, ���� ������� ����� �������. � ������ ������ �������, ��� ���������� �������� ����� ��������, ���� �����
��������� ����� �������� ������� budget ������� Project, ������� ������� � ����������� ON*/
begin -- ������ ������������ ���� / ���������� ��������
	declare @budgetOld int
	declare @budgetNew int
	declare @projectNumber int

	select @budgetOld = (select budget from deleted) /* ����� ���� ������� ���������� @budgetOld. �� ����������� �� �������� ������� budget, ������� ���� �������� (���������� ��������)
	�� ����� ���������� update. ��������� �������� ���� �������� (������ ��������), �� ��� ����������� � ����������� ������� deleted*/
	select @budgetNew = (select budget from inserted) /* ����� ���� ������� ���������� @budgetNew. �� ����������� �� �������� ������� budget, ������� ���� �������� (����� ��������)
	�� ����� ���������� update. ��������� �������� ���� �������� (����� ��������), �� ��� ����������� � ����������� ������� inserted*/
	select @projectNumber = (select budget from deleted) /* ����� ���� ������� ���������� @budgetOld. �� ����������� �� �������� ������� budget, ������� ���� �������� (���������� ��������)
	�� ����� ���������� update. ��������� �������� ���� �������� (������ ��������), �� ��� ����������� � ����������� ������� deleted*/
	
	insert into AuditBudget /* ����� �� ������� ������� AuditBudget. ��� ����� ����� �������� �����. � ��� ������� ����� ��������� ��������, � ��� ����� ����������, ������� ������ ���� ���������
	�������� �� ������ deleted � inserted. ������ �����, � ������ ����������� �������� ������ ������� ���� ��������� � ��� ������������, ������������ ��������� */
	values
	(@projectNumber,user_name(),getdate(),@budgetOld, @budgetNew)
end
;