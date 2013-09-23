clear all
mov=VideoReader('larvae1.mp4');
nframes=mov.NumberOfFrames;
I=read(mov,1);
empty = zeros([size(I,1), size(I,2), 1, nframes], 'uint8');
orig = zeros([size(I,1), size(I,2), 3, nframes], 'uint8');
position=zeros([size(I,1), size(I,2)], 'uint8');
%find average
avg_frame=rgb2gray(I)*.1;
for i=2:10
        temp_frame=read(mov,i);
        temp_frame=rgb2gray(temp_frame)*.1;
        avg_frame=avg_frame+temp_frame;
end
new_average=0;
update=0;
col_win=-1;
%frame manipulation
for i=1:nframes
    if(i==50)
        update=1;
    end
    
    %convert to gray scale
    temp_frame=read(mov,i);
    orig(:,:,:,i)=temp_frame;
    gframe=rgb2gray(temp_frame);
    
    
    %decide to update average
    if(new_average==1)
        new_avg=new_avg+gframe*.1;
    end
    if(mod(i,50)==0&&update==1)
        new_average=1;
        new_avg=gframe*.1;
    end
    if(mod(i,50)==9&&update==1)
        new_average=0;
        avg_frame=new_avg;
    end


    gframe=gframe-avg_frame;
    
    
    s=size(I);
    
    for k=1:s(1)
        for j=1:s(2)
                if(gframe(k,j)>50)
                    gframe(k,j)=255;
                else
                    gframe(k,j)=0;
                end
        end
    end

        %erode everything outside old window if window created
    if (col_win~=-1)
        keep_frame=gframe(row_win,col_win);
        seD = strel('diamond',1);
        gframe = imerode(gframe,seD);
        gframe = imerode(gframe,seD);
        gframe(row_win,col_win)=keep_frame;        
    end
    
    empty(:,:,i)=gframe;  
    
    stats = regionprops(gframe, {'Centroid','Area'});
    if ~isempty([stats.Area])
        old_stats=stats;
        areaArray = [stats.Area];
        [junk,idx] = max(areaArray);
        c = stats(idx).Centroid;
        c = floor(fliplr(c));
        width = 2;
        row = c(1)-width:c(1)+width;
        col = c(2)-width:c(2)+width;
        %create window
        row_win=c(1)-10:c(1)+10;
        row_win(row_win>s(1))=[];
        row_win(row_win<0)=[];
        col_win=c(2)-10:c(2)+10;
        col_win(col_win>s(1))=[];
        col_win(col_win<0)=[];
        orig(row,col,1,i) = 255;
        orig(row,col,2,i) = 0;
        orig(row,col,3,i) = 0;
    else
        stats=old_stats;
        areaArray = [stats.Area];
        [junk,idx] = max(areaArray);
        c = stats(idx).Centroid;
        c = floor(fliplr(c));
        width = 2;
        row = c(1)-width:c(1)+width;
        col = c(2)-width:c(2)+width;
        %create window
        row_win=c(1)-10:c(1)+10;
        row_win(row_win>s(1))=[];
        row_win(row_win<0)=[];
        col_win=c(2)-10:c(2)+10;
        col_win(col_win>s(1))=[];
        col_win(col_win<0)=[];
        orig(row,col,1,i) = 255;
        orig(row,col,2,i) = 0;
        orig(row,col,3,i) = 0;
    end
    
    %create position graph
   position=heat(position,c);
    %position(c(1),c(2))=position(c(1),c(2))+1;
end
