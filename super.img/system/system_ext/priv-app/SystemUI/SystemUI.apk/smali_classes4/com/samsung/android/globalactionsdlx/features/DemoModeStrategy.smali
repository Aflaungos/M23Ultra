.class public Lcom/samsung/android/globalactionsdlx/features/DemoModeStrategy;
.super Ljava/lang/Object;
.source "DemoModeStrategy.java"

# interfaces
.implements Lcom/samsung/android/globalactionsdlx/presentation/strategies/ActionInteractionStrategy;


# instance fields
.field private final mResourcesWrapper:Lcom/samsung/android/globalactionsdlx/util/ResourcesWrapper;

.field private final mToastController:Lcom/samsung/android/globalactionsdlx/util/ToastController;


# direct methods
.method public constructor <init>(Lcom/samsung/android/globalactionsdlx/util/ToastController;Lcom/samsung/android/globalactionsdlx/util/ResourcesWrapper;)V
    .registers 3
    .param p1, "toastController"    # Lcom/samsung/android/globalactionsdlx/util/ToastController;
    .param p2, "resourcesWrapper"    # Lcom/samsung/android/globalactionsdlx/util/ResourcesWrapper;

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 14
    iput-object p1, p0, Lcom/samsung/android/globalactionsdlx/features/DemoModeStrategy;->mToastController:Lcom/samsung/android/globalactionsdlx/util/ToastController;

    .line 15
    iput-object p2, p0, Lcom/samsung/android/globalactionsdlx/features/DemoModeStrategy;->mResourcesWrapper:Lcom/samsung/android/globalactionsdlx/util/ResourcesWrapper;

    .line 16
    return-void
.end method


# virtual methods
.method public onPressEmergencyModeAction()Z
    .registers 4

    .line 20
    iget-object v0, p0, Lcom/samsung/android/globalactionsdlx/features/DemoModeStrategy;->mToastController:Lcom/samsung/android/globalactionsdlx/util/ToastController;

    iget-object v1, p0, Lcom/samsung/android/globalactionsdlx/features/DemoModeStrategy;->mResourcesWrapper:Lcom/samsung/android/globalactionsdlx/util/ResourcesWrapper;

    const v2, 0x10405ad

    invoke-virtual {v1, v2}, Lcom/samsung/android/globalactionsdlx/util/ResourcesWrapper;->getString(I)Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Lcom/samsung/android/globalactionsdlx/util/ToastController;->showToast(Ljava/lang/String;I)V

    .line 21
    return v2
.end method
