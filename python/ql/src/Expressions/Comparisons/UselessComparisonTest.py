  class KeySorter:

      def __init__(self, obj):
          self.obj = obj

      def __lt__(self, other):
          return self._compare(self.obj, other.obj) < 0

      def _compare(self, obj1, obj2):
          if obj1 < obj2:
              return -1
          elif obj1 < obj2:
              return 1
          else:
              return 0
