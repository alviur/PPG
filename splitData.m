%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function splittedFrame = splitData(frame, splitFlags)

    beginFrame = 1;
    contCell = 1;
    erasedFrames = 0;

    for i=1:length(splitFlags)

        tempArray = frame(beginFrame:splitFlags(i)+1);
        tempArray(tempArray==254)=0;
        
        %if(length(tempArray)==40)
        if(length(tempArray)==24)    
            
            %splittedFrame{contCell} = tempArray(3:end-6);
            splittedFrame{contCell} = tempArray(1:end-2);
            contCell = contCell +1;
        else
            erasedFrames = erasedFrames + 1;

        end
        

        beginFrame = splitFlags(i) + 2;

    end
 display(['Erased freames: ' int2str(erasedFrames)])

end

