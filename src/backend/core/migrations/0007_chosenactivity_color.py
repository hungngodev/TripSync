# Generated by Django 5.1.2 on 2024-11-21 06:56

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("core", "0006_chosenactivity_description_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="chosenactivity",
            name="color",
            field=models.CharField(max_length=255, null=True),
        ),
    ]