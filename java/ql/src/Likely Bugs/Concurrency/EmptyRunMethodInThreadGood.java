class GoodWithOverride{

  public void runInThread(){
    Thread thread = new Thread(){
      @Override
      public void run(){
        System.out.println("Doing something");
      }
    };
    thread.start;
  }

}

class GoodWithRunnable{

  public void runInThread(){
    Runnable thingToRun = new Runnable(){
      @Override
      public void run(){
        System.out.println("Doing something");
      }
    };

    Thread thread = new Thread(thingToRun());
    thread.start();
  }

}