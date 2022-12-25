unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, uVisualisation, Math, ListUnit, Spin;

type

    TPoint = record
      Name: Byte;
      X, Y: Integer;
    End;

    DeykstRes = Array of Integer;
    TMatrix = Array of Array of Integer;

  TfrmMain = class(TForm)
    AskLabel: TLabel;
    VerticeEdit: TSpinEdit;
    MatrixLabel: TLabel;
    sgMatrix: TStringGrid;
    eStart: TSpinEdit;
    eFinish: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnStart: TButton;
    mRoutes: TMemo;
    lblLong: TLabel;
    lblShort: TLabel;
    lblCenter: TLabel;
    brnDraw: TButton;
    Label3: TLabel;
    procedure VerticeEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    function FindWays: TList;
    procedure brnDrawClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Function CreateMatrix(): TMatrix;
  end;

Const
    Infinity = 100000; //Бесконечно большое значение
    Rad= 15;  //Радиус окружности на графе
    ArrowLen = 15; //Длина стрелочки
    ArrowRot= Pi/12; //Угол поворота линий описывающих стрелочку относ. ребра

Var
    frmMain: TfrmMain;
    A: TMatrix; //матрица смежности
    Ways: TList; //список путей
implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
Var
    F: textFile;
    N, I, J, Val: Integer;
begin
    sgMatrix.Cells[1,0] := '  0 ';
    sgMatrix.Cells[0,1] := '  0 ';
    AssignFile(F, 'd.txt');
    Reset(f);
    Readln(F, N);
    For I := 1 to N do
        VerticeEdit.Value := I;
    For i := 1 to N do
    Begin
        For J := 1 to N do
        Begin
            Read(F, Val);
            sgMatrix.Cells[J, I] := IntToStr(Val);
        End;
    End;
end;

//Алгоритм Дейкстры
function Deykstra(start:Byte; out Way:DeykstRes) : DeykstRes;
var
  Used: Mn; //Множество посещённых вершин
  i,j,min:integer;
begin
  Used:= [];
  SetLength(Result,High(A)+1); //Размерность результата
  SetLength(Way,High(A)+1);
  for i := 0 to High(Result) do
  begin
    Result[i]:=A[start,i];    //Прямые пути
    Way[i]:=start;
  end;

  for j := 0 to High(A) do    //Текщей должна побывать каждая вершина
  begin
    Used:=Used + [start];
    //Для каждого соседа тек. вершины
    for i := 0 to High(Result) do
      if Not (i in Used) then //Вешина ещё в графе
        if Result[i] > Result[start] + A[start,i] then
        begin
          Result[i] := Result[start] + A[start,i];
          Way[i]:=start;
        end;
    //Сл. вершина  - минимальная ещё принадлежащая  графу
    min:=MaxInt;
    for i := 0 to High(Result) do
      if Not (i in Used) And (Result[i] < min) then
      begin
        min:=Result[i];
        start:=i;
      end;
  end;
end;

//Центр Ор. графа
function GraphCenter (FloidRes:TMatrix):Byte;
var
  MaxWay:array of Integer; //Самый длинный путь из данной вершины
  i,j:Integer;
begin
  SetLength(MaxWay,High(A)+1);
  //Поиск самы длинных маршрутов для каждой вершины
  for i:= 0 to High(A)  do
  begin
    MaxWay[i]:=FloidRes[0,i];
    for j:= 0 to High(A) do
      if MaxWay[i] < FloidRes[j,i] then
        MaxWay[i]:= FloidRes[j,i];
  end;

  //Наимньший из ниабольших путей
  Result:=0;
  for i := 0 to High(A) do
    if MaxWay[i] < MaxWay[Result] then
      Result:=i;
end;

//Алгоритм Флойда
function Floid:TMatrix;
var
  i,j,k:Integer;
begin
  SetLength(Result,High(A)+1,High(A)+1);
  //Начальные зачения из матрицы цен
  for i:= 0 to High(A) do
    for j:= 0 to High(A) do
      Result[i,j]:=A[i,j];

  //Сам алгоритм
  for k:=0 to High(A) do
    for i:= 0 to High(A) do
      for j := 0 to High(A) do
        if Result[i,k] + Result[k,j] < Result[i,j] then
          Result[i,j]:= Result[i,k] + Result[k,j];
end;

procedure DrawPoint(var bmp:TBitmap; Point:TPoint);
begin
  bmp.Canvas.Ellipse(Point.X - Rad ,Point.Y - Rad,Point.X + Rad ,Point.Y + Rad);
  bmp.Canvas.FloodFill(Point.X,Point.Y,clBlack,fsBorder);
  bmp.Canvas.TextOut(Point.X - 4,Point.Y - 8,IntToStr(Point.Name));
end;

//Построить граф
function Draw(BmpHeight,BmpWidth:Integer; Center:Byte):TBitmap;
var
  BmpRad:Integer; //Радиус окружности в которую вписвается граф;
  AngleStep:Real; //Шаг угловой координаты между вершинами графа
  i,j:Integer;
  Points:array of TPoint;
  X1,X2,Y1,Y2,X3,Y3:Integer;
  Phi:Real;
begin
  SetLength(Points,High(A)+1);
  Result:=TBitmap.Create;
  Result.Height:=BmpHeight;
  Result.Width:=BmpWidth;
  Result.Canvas.Brush.Color:=clGreen;

  //Радиус (азмер картинки в полярных координатах)
  if BmpHeight < BmpWidth then
    BmpRad:=(BmpHeight div 2) - Rad - 5
  else
    BmpRad:=(BmpWidth div 2) - Rad - 5;
  AngleStep:= 2*Pi/(High(A));

  //Сами вершины
  j:=0;
  for i:= 0 to High(A) do
  begin
    if i= Center Then Continue; //Центр графа рисуем отдельно
    //Заносим вершину в список
    Points[i].Name:=i;
    Points[i].X:=BmpRad + 2*Rad + 10 + Round(BmpRad * Cos(Pi /10   + j*AngleStep));
    Points[i].Y:=BmpRad + Rad + 5 - Round(BmpRad * Sin(Pi /10  + j*AngleStep));
    //Рисуем
    DrawPoint(Result,Points[i]);
    j:=j+1;
  end;
  //Центр графа
  Points[Center].Name:=Center;
  Points[Center].X:=BmpRad + Rad + 5;
  Points[Center].Y:=BmpRad + Rad + 5;
  DrawPoint(Result,Points[Center]);

  //Рёбра
  for i:= 0 to High(A) do
    for j:= 0 to High(A) do
      if A[i,j] <> Infinity then
      begin
        if Abs(Points[i].Y - Points[j].Y) < Rad*2 then  //Незначительная разница в координатах по высоте
        begin
          Y1:=Points[i].Y;
          Y2:=Points[j].Y;
          //Ведём от левого края правого к правому краю левого
          if Points[i].X < Points[j].X then
          begin
            X1:=Points[i].X + Rad;
            X2:=Points[j].X - Rad
          end
          else
          begin
            X1:=Points[i].X - Rad;
            X2:=Points[j].X + Rad
          end
        end
        else
        begin         //Большое различие по высоте
          X1:=Points[i].X;
          X2:=Points[j].X;
          //Ведём от Нижнего края верхнего к верхнему краю нижнего
          if Points[i].Y < Points[j].Y then
          begin
            Y1:=Points[i].Y + Rad;
            Y2:=Points[j].Y - Rad
          end
          else
          begin
            Y1:=Points[i].Y - Rad;
            Y2:=Points[j].Y + Rad
          end
        end;

        Result.Canvas.MoveTo(X1,Y1);
        Result.Canvas.LineTo(X2,Y2);


        //Стрелочка!!!!!!!!
        Phi:=ArcTan(Abs(Y1-Y2) / Abs(X1-X2)); //Уравнение ребра в полярных координатах с центром в вершине приемнике
        //arctg не определяет четверть угла
        if Y2-Y1 < 0 then
          Phi:=-Phi;
        if X2-X1 > 0 then
          Phi:=Pi - Phi;
        //Сама стрелочка
        X1:=X2 + Round(ArrowLen*Cos(Phi-ArrowRot));
        Y1:=Y2 - Round(ArrowLen*Sin(Phi-ArrowRot));
        Result.Canvas.LineTo(X1,Y1);
        X3:=X2 + Round(ArrowLen*Cos(Phi+ArrowRot));
        Y3:=Y2 - Round(ArrowLen*Sin(Phi+ArrowRot));
        Result.Canvas.MoveTo(X2,Y2);
        Result.Canvas.LineTo(X3,Y3);
        Result.Canvas.LineTo(X1,Y1);

        //Подпись
        X1:=X2 + Round(ArrowLen*3*Cos(Phi));
        Y1:=Y2 - Round(ArrowLen*3*Sin(Phi));
        Result.Canvas.Brush.Color:=clYellow;
        Result.Canvas.TextOut(X1,Y1,IntToStr(A[i,j]));
        Result.Canvas.Brush.Color:=clGreen;
      end;
end;

procedure TfrmMain.brnDrawClick(Sender: TObject);
Var
    frmVis: TfrmVisual;
    Center: Byte;
begin
    Try
        frmVis := TfrmVisual.Create(Self);
        Center:= GraphCenter(Floid);
        frmVis.PaintArea.Picture := TPicture(Draw(frmVis.PaintArea.Height, frmVis.PaintArea.Width, Center));
        frmVis.ShowModal;
    Finally
        frmVis.free();
    End;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  i,j:integer;
  Rez:Integer;
  Code:Integer;
  x,Ways:TList;
  ShortWay,Way:DeykstRes;
  WayName:string;
  Center:Byte;
begin
    A := CreateMatrix();
    //Все пути
    Ways:=FindWays;

    //Вывод путей
    x:=Ways^.Next;
    while x<> nil do
    begin
      mRoutes.Lines.Add( IntToStr(x^.Way.Cost) + ' - ' + x^.Way.Name );
      x:=x^.Next;
    end;

    //Самый длинный путь
  x:=Ways;
  while x^.Next<> nil do
    x:=x^.Next;
  lblLong.Caption:= 'Самый длинный путь: ' + x^.Way.Name + '(' +
                                      IntToStr(x^.Way.Cost) + ')';

  //Находим кратчайший путь ( алгоритм Дейкстры)
  ShortWay:=Deykstra(eStart.Value,Way);
  lblShort.Caption:= 'Самый короткий путь: ';
  //Выводим сам путь
  WayName:=IntToStr(eFinish.Value);
  i:=Way[eFinish.Value];
  while i <> eStart.Value do
  begin
    WayName:=WayName + IntToStr(i);
    i:=Way[i];
  end;
  WayName := WayName + IntToStr(eStart.Value);
  //Разворачиваем строку
    for i:= Length(WayName) downto 1 do
    lblShort.Caption:=lblShort.Caption + WayName[i] + ' ';
  //Бесконечность - пути нет
  lblShort.Caption:=lblShort.Caption +'(' +  IntToStr(ShortWay[eFinish.Value]) + ')' ;

  //Центр графа
  Center:= GraphCenter(Floid);
  lblCenter.Caption:='Центр графа: ' + IntToStr(Center);
end;

Function TfrmMain.CreateMatrix(): TMatrix;
Var
    Matrix: TMatrix;
    N, I, J: Integer;

Begin
    N := VerticeEdit.Value;
    SetLength(Matrix, N, N);
    For I := 0 to (N - 1) do
        For J := 0 to (N - 1) do
        Begin
            Matrix[I, J] := StrToInt(sgMatrix.Cells[J + 1, I + 1]);
            If (Matrix[I][J] = 0) then
            Begin
                Matrix[I][J] := Infinity;
            End;
        End;
    Result := Matrix;
End;

procedure TfrmMain.VerticeEditChange(Sender: TObject);
begin
    sgMatrix.RowCount := VerticeEdit.Value + 1;
    sgMatrix.ColCount := VerticeEdit.Value + 1;
    sgMatrix.Cells[VerticeEdit.Value,0] := '  ' + IntToStr(VerticeEdit.Value - 1);
    sgMatrix.Cells[0,VerticeEdit.Value] := '  ' + IntToStr(VerticeEdit.Value - 1);
end;


//Посик путей между вершинами
function TfrmMain.FindWays:TList;
var
  Src, Dest: Integer;
  NullWay:TWay;

  procedure FindRoute(V: Integer; Way:TWay);
  var
    i: Integer;
    NewWay:TWay;
  begin
    if V = Dest then                   //Нашли
      AddToSortedList(Way,Ways)
    else
    for i := 0 to High(A[V]) do     //Для каждой вершины
      if (A[V, i] <> Infinity) and Not( i in Way.Used) then        //Туда есть переход и там ещё не были
      begin
        NewWay.Used:= Way.Used + [i];
        NewWay.Name:= Way.Name + IntToStr(i) + ' ';
        NewWay.Cost:=Way.Cost + A[V,i];
        FindRoute(i,NewWay);
      end;
  end;

begin
    Ways:=NewList;
    mRoutes.Clear;
    Src := eStart.Value; //Вершина - источник
    Dest := eFinish.Value;//Вершина приемник
    with NullWay do
    begin
      Name:= IntToStr(Src) + ' ';
      Cost:=0;
      Used:= [Src];
    end;
    FindRoute(Src,NullWay);
    Result:=Ways;
end;


end.
