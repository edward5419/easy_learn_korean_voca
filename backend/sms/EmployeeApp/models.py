from django.db import models

class User(models.Model):
    userId = models.AutoField(primary_key=True)
    email = models.CharField(max_length=50)
    

class Chapter(models.Model):
    chapterId = models.AutoField(primary_key=True)
    chapterTopic = models.CharField(max_length=100,unique=True)
    chapterLevel = models.PositiveIntegerField()

class Voca(models.Model):
    vocaId = models.AutoField(primary_key=True)
    vocaKr = models.CharField(max_length=50)
    vocaCn = models.CharField(max_length=50)
    vocaChapter = models.PositiveIntegerField()
    vocaExp = models.CharField(max_length=1000)
    chapter = models.ForeignKey(
        Chapter,
        on_delete=models.CASCADE,
    )

class VocaMemo(models.Model):
    vocaMemoId = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    voca = models.ForeignKey(Voca, on_delete=models.CASCADE)
    vocaMemo = models.BooleanField(default=0)

class ChapterMemo(models.Model):
    chapterMemoId = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    memoDate = models.DateField(auto_now=True)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
    chapterMemo = models.BooleanField(default=0)




