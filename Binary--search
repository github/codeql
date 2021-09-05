//C program to find the element of an array using binary search method when elements of the array are shuffled.
#include<stdio.h>
int main()
{
  /*declaring array of type int,counter variables,three variables low,mid & high to keep track of the element that is to be searched*/
  int a[10],i,j,temp,n,low,mid,high,key,flag=0;
  printf("Enter the size:\n");
  scanf("%d",&n);
  printf("Enter the elements :\n");
  for(i=0;i<n;i++)
    scanf("%d",&a[i]);
  printf("Enter the key element:\n");
  scanf("%d",&key);//storing the search element
  for(i=0;i<n;i++)
  {
    for(j=0;j<n-i-1;j++)
    {
      if(a[j]>a[j+1])
      {
       temp=a[j];
       a[j]=a[j+1];
       a[j+1]=temp;
       }
     }
   }
   printf("Sorted elements are:\n");
   for(i=0;i<n;i++)
     printf("%d ",a[i]);
   low=0;  //initializing the lowest index to low and highest index of array to high
   high=n-1;

   while(low<=high)
   {
       mid=(low+high)/2; //calculating the middle index and assigning it to mid
       if(a[mid]==key)   /*checking if the search element is equal to middle element.If true print the position .if false then check if the search element is less than
                         or greater than middle element*/
       {
         printf("\nFound at position %d\n",mid);
         flag=1;
       }
       else if (key<a[mid])
          high=mid-1;   //shifting the highest index to mid-1
       else
         low=mid+1;  //shifting the lowest index to mid+1
    }
    if(flag==0)
      printf("\nNot found");
    return 0;
  }
