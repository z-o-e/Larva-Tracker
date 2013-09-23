function[imagein]= heat(imagein, c)
s=size(imagein);
index=0:10;
index=fliplr(index);
for i=index
    row_win=c(1)-i:c(1)+i;
    row_win(row_win>s(1))=[];
    row_win(row_win<0)=[];
    col_win=c(2)-i:c(2)+i;
    col_win(col_win>s(1))=[];
    col_win(col_win<0)=[];
    imagein(row_win,col_win)=imagein(row_win,col_win)+1;
end

end